SHELL:=/bin/bash

all: check_root check_os tools tljh usehttps other nativeauth libspatialindex netcdf_libs pythonlibs gdal rasterio java netlogo r-warning final-message

check_root:
	@if [[ `whoami` = "root" ]]; then \
            echo "You are root, ok"; \
        else \
            echo -e "\nYou must run this script as root not as `whoami`.\nRun it with 'sudo make' instead\n"; \
            exit 1; \
        fi

check_os:
	@DIST=`lsb_release -i | awk '{print $$3}'`; if [[ $${DIST} = "Ubuntu" ]]; then \
            echo "Running in Ubuntu, ok"; \
        else \
            echo -e "\nOnly Ubuntu supported, you are running $${DIST}\n"; \
            exit 1; \
        fi

tools:
	DEBIAN_FRONTEND=noninteractive apt -y install git curl

tljh:
	curl -L https://tljh.jupyter.org/bootstrap.py | sudo -E python3 - --admin tljhadmin

usehttps:
	openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem -subj "/C=US"
	mkdir -p /etc/mycerts
	MY_IP=`curl https://ipecho.net/plain`; \
              echo; echo "Configuring website with IP number only at $${MY_IP}"; \
              mv certificate.pem /etc/mycerts/$${MY_IP}.cert; \
              mv key.pem /etc/mycerts/$${MY_IP}.key; \
              tljh-config set https.enabled true; \
              tljh-config set https.tls.key /etc/mycerts/$${MY_IP}.key; \
              tljh-config set https.tls.cert /etc/mycerts/$${MY_IP}.cert
	tljh-config reload proxy

other:
	tljh-config set user_environment.default_app jupyterlab
	/opt/tljh/user/bin/pip install --upgrade pip
	/opt/tljh/hub/bin/pip3 install --upgrade pip

nativeauth:
	tljh-config set auth.type nativeauthenticator.NativeAuthenticator
	tljh-config reload proxy

libspatialindex:
	rm -fr /tmp/libspatialindex
	mkdir /tmp/libspatialindex
	@DIST_VER=`lsb_release -r | awk '{print $$2}'`; \
        if [[ $${DIST_VER} = "20.04" ]]; then \
            echo "Installing libspatialindex-c6 for Ubuntu $${DIST_VER}"; \
	    DEBIAN_FRONTEND=noninteractive apt -y install libspatialindex-c6; \
        else \
	    echo "Warning, only Ubuntu 20.04 is supported" \
            echo "Installing libspatialindex-c4v5 for Ubuntu $${DIST_VER}"; \
            DEBIAN_FRONTEND=noninteractive apt -y install libspatialindex-c4v5; \
        fi

netcdf_libs:
	DEBIAN_FRONTEND=noninteractive apt -y install libhdf5-serial-dev netcdf-bin libnetcdf-dev

pythonlibs:
	/opt/tljh/user/bin/pip install numpy scipy folium fiona shapely cesiumpy matplotlib pandas
	/opt/tljh/user/bin/pip install netCDF4
	/opt/tljh/user/bin/pip install rtree geopandas plotly sklearn keras tensorflow
	/opt/tljh/user/bin/pip install pysal # see https://github.com/pysal/pysal/issues/1070

gdal:
	DEBIAN_FRONTEND=noninteractive apt -y install libgdal-dev
	DEBIAN_FRONTEND=noninteractive apt -y install python3-gdal

rasterio:
	/opt/tljh/user/bin/pip install rasterio # depends on GDAL

java:
	@DIST_VER=`lsb_release -r | awk '{print $$2}'`; \
        JAVA_VER=openjdk-16-jdk; \
        if [[ $${DIST_VER} = "20.04" ]]; then \
            echo "Installing $${JAVA_VER} for Ubuntu $${DIST_VER}"; \
            DEBIAN_FRONTEND=noninteractive apt-get -y install $${JAVA_VER} \
               || (echo -e "\nCheck if a different version of java is available and edit Makefile accordingly\n"; exit 1; );  \
	else \
            echo "Don't know what java to install for Ubuntu $${DIST_VER}"; \
            exit 1; \
        fi

r-libs:
	DEBIAN_FRONTEND=noninteractive apt -y install r-base r-cran-sp r-cran-rjava
	DEBIAN_FRONTEND=noninteractive apt -y install libproj-dev # dependency for RGDAL below
	# missing packages: sdm pdbZMQ
	for item in raster dismo repr IRdisplay evaluate crayon uuid digest devtools; do \
                echo -e "****************\n *** $${item} ***\n****************"; \
                Rscript --slave --no-save --no-restore-history -e \
                    "install.packages(pkgs='$${item}', dependencies=TRUE, repos=c('http://ftp.heanet.ie/mirrors/cran.r-project.org/')); if ( ! library('$${item}', character.only=TRUE, logical.return=TRUE) ) {quit(status=1, save='no')}"; \
        done
	Rscript --slave --no-save --no-restore-history -e \
            "install.packages(pkgs='rgdal', dependencies=TRUE, repos=c('http://ftp.heanet.ie/mirrors/cran.r-project.org/')); if ( ! library('rgdal', character.only=TRUE, logical.return=TRUE) ) {quit(status=1, save='no')}"
	
kernel-r:
	exit 1

r-warning:
	echo "Not installed anything about R"

netlogo:
	$(eval NETLOGO_VER := 6.2.0)
	mkdir -p /opt
	cd /opt; wget https://ccl.northwestern.edu/netlogo/$(NETLOGO_VER)/NetLogo-$(NETLOGO_VER)-64.tgz; tar xf NetLogo-$(NETLOGO_VER)-64.tgz;
	PATH=$${PATH}:/opt/NetLogo\ $(NETLOGO_VER)/; /opt/tljh/user/bin/pip install pyNetLogo jpype1
	echo export PATH="/opt/NetLogo\ $(NETLOGO_VER)":'$$PATH' >> .bashrc             # sudo-enabled user
	echo export PATH="/opt/NetLogo\ $(NETLOGO_VER)":'$$PATH' >> ~/.bashrc           # root
	echo export PATH="/opt/NetLogo\ $(NETLOGO_VER)":'$$PATH' >> /etc/skel/.bashrc   # future users
	echo Netlogo has been installed in /opt > netlogo

final-message:
	@echo
	@echo "***************************************************************************"
	@echo "* Congratulations, your JupyterHub installation is up and running         *"
	@echo "* It uses a self-signed certificate, so it is somewhat secure, but it     *"
	@echo "* will require a browser exception. It is recommend that you register a   *"
	@echo "* domain name (rather than using the IP number as you are doing now)      *"
	@echo "* and use https://letsencrypt.org/docs/ to install a CA certificate       *"
	@echo "* which will not need browser exceptions.                                 *"
	@echo "***************************************************************************"
	@echo
	@echo "***************************************************************************"
	@echo "* For final **IMPORTANT** configurations, one last small step is needed:  *"
	@echo "* just edit and run the post_makefile_script                              *"
	@echo "***************************************************************************"
	@echo
