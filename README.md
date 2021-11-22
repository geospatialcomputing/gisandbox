# gisandbox
GISandbox is a play place for researchers and educators to learn about, experiment with, and advance geographic information systems and science (GIS) and geospatial computing.

## the current version is a (working) prototype with some rough edges

Includes R and python with a number of relevant geospatial packages.

# Instructions

1. Create a server instance in Jetstream, e.g. via [Atmosphere](https://use.jetstream-cloud.org/) or Google Cloud, AWS, or somewhere. Only Ubuntu LTS 20.04 is supported for now. It might work on other Debian-based Linux distributions.
2. Login into that system
3. Make sure you have root access and make is installed, e.g. by running `sudo apt install make` (if this fails, you cannot move forward)
4. Clone this repository and cd into the cloned directory
5. Run `sudo make`
6. Open and **EDIT** `post_makefile_script`, following the instructions inside there (we will eventually document them better here)
7. Run `sudo ./post_makefile_script`
8. Enjoy your newly installed GISandbox instance, which you can login into via Jupyterhub.

# Notes
1. This does everything that https://tljh.jupyter.org/en/latest/install/custom-server.html suggests doing for you, **besides** creating users
3. The Jupyterhub admin has a `tljhadmin` username, and the account needs to be created with the `nativeauthenticator` like anyone else, however the email will *not* need to be validated for this user. This is part of TLJH settings, as described in step 1 of https://tljh.jupyter.org/en/latest/install/custom-server.html

