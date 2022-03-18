[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/geospatialcomputing/gisandbox/HEAD?filepath=/Welcome.ipynb)

# GISandbox
GISandbox is a play place for researchers and educators to learn about, experiment with, and advance geographic information systems and science (GIS) and geospatial computing.

The current version is a well working prototype. It includes R and Python with a number of relevant geospatial packages.
It supports both [MyBinder](https://mybinder.org/) (with all its caveats) and custom install in the cloud.
Neither of them includes *backups* of any kind.

GISandbox greatly simplifies user management thanks to pre-made email-based [NativeAuthenticator](https://github.com/jupyterhub/nativeauthenticator) setup, which you will have to only minimally configure (as below).

# Instructions

For MyBinder, just click the button above and you are done. Note that [only the Python environment is supported on MyBinder](https://github.com/geospatialcomputing/gisandbox/issues/10).

For cloud deployment: 

1. Create a server instance in your favorite cloud, e.g. in Jetstream via the [Atmosphere](https://use.jetstream-cloud.org/) interface.
It should work identically on Google Cloud, AWS, or somewhere else.
Only Ubuntu LTS 20.04 is supported for now. It might already be working  on other Debian-based Linux distributions, but we don't have the time to test and support anything else (if you do, please [submit an issue](https://github.com/geospatialcomputing/gisandbox/issues/new) with your positve or negative experience about it). It will not work out of the box with non-Debian based distribution, since it uses `apt`, however we have reduced the number of `apt` calls to just two and it should be easy to port it to `yum`-based systems. If you do, please make a pull request!
3. Login into that system
4. Make sure you have root access and `make` is installed, e.g. by running `sudo apt install make` (if this fails, you cannot move forward)
5. Clone this repository and cd into the cloned directory
6. Checkout the version you intend to utilize (could be the HEAD if you so prefer, or better one of the official releases aka tags)
7. Run `sudo make`
8. When that completes successfully, open and **EDIT** in the shell the [`post_makefile_script`](post_makefile_script), following the instructions inside there (we will eventually document them better here)
9. Run `sudo ./post_makefile_script` it will conclude with a message such as
```
***************************************************************************                                                                 
*   Congratulations! Now you can login in your GISandbox instance at:     *                                                                 
*                   https://149.165.168.35                                *                                                                  
***************************************************************************
```
9. Enjoy your newly installed GISandbox instance, which you can login into via Jupyterhub, by pointing your browser to the specified IP. Note that being a temporarily IP number the HTTPS certificate is self-signed and the browsers will complain about it.
10. The Jupyterhub administrator username is `tljhadmin`, and the account needs to be created with the `nativeauthenticator` like anyone else, however the email will *not* need to be validated for this one user, so create the account as soon as the server is up, to avoid the risk that someone else does. This is part of TLJH settings, as described in step 1 of https://tljh.jupyter.org/en/latest/install/custom-server.html
11. Optionally, to avoid the browser certificate complains and to have a more permanent/professional URL, you may register a Domain Name, create a DNS instance, get signed certificates from an official authority such as [Let's Encrypt](https://letsencrypt.org/) and configure all of this in your server. See [CERTIFICATE.md](CERTIFICATE.md) for details about that.
