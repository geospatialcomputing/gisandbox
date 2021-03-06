# Custom settings

GISandbox uses [NativeAuthenticator](https://github.com/jupyterhub/nativeauthenticator) to authenticate users, with the very convenient
[self-approval achieved via emails](https://native-authenticator.readthedocs.io/en/latest/options.html#allow-self-serve-approval).
Everything that is generic enough, is already configured for you, but you **MUST** take care of a few items, as follows.

1. **Terms of service** (optional, suggested)
If you intend to utilize terms of service, uncomment the `auth.NativeAuthenticator.tos` line in `post_makefile_script` and
include the desired URL (it could be on same or different server, with a relative or an absolute link)

2. **Captcha** (optional, highly recommended for servers staying up more than few hours)
To prevent scripted attacks, [register with ReCaptcha](https://www.google.com/recaptcha/admin/create) (have to select v2) and
uncomment the `auth.NativeAuthenticator.recaptcha_*` lines completing them with the `keys` that ReCaptcha
provided you

3. **Email authentication** (optional, highly recommended for servers with more than a handful of users)
   1. Uncomment `auth.NativeAuthenticator.allow_self_approval_for` and select a desired regular expression for the desired email address which you would like to enable without your intervention (the included regular expression will allow anybody with an `.edu` account). Users who register with different email will appear in the admin control panel [as normal](https://native-authenticator.readthedocs.io/en/latest/quickstart.html#authorize-un-authorize-or-discard-users) 
   2. Decide if you want to use an external email server (in which case you must uncomment `c.Authenticator.self_approval_server` and add its details, **including the password**, so a dedicated email account is strongly reccomended) or if you want to install a passwordless email server in your cloud instance (in which case you don't need to do anything in this file, but you do have to install the local email server separately). See the [documentation](https://native-authenticator.readthedocs.io/en/latest/options.html#allow-self-serve-approval) for more details
   3. Uncomment `c.Authenticator.self_approval_email` with a template email to send. A barebone one is provided as example. Don't forget to warn the recipients to **not** click on the link if they have not registered themselves, otherwise an attacker could just create a bunch of accounts and hope that someone clicks on the email enabling at least one

4. **Decide for a secret key** (mandatory if you selected email authentication, otherwise useless)
To generate cryptographic URLs to authenticate users, NativeAuthenticator needs a key. The key cannot be public
otherwise anybody can generate those URLs and authenticate themselves without having access to the email. As such,
GISandbox provides a randomly-generated `auth.NativeAuthenticator.secret_key`, which you need to uncomment. A drawback
of this approach is that the key is re-generated at server restart, immediately breaking any URLs which has not being
clicked on yet, regardless of their expiration date. If you are not concerned about this issue, simply uncomment the
line containing `auth.NativeAuthenticator.secret_key`. Otherwise, edit that line by removing the random generator and
including a **secret** key of your choice, making sure it's not shared e.g. in your clone of this repository

6. Add anything else you may want from https://native-authenticator.readthedocs.io/ (for example enforcing password strength,
block users after failed logins, etc)  taking in mind that this documentation 
uses the `jupyterhub_config.py` syntax, not the TLJH one which you are supposed to use here. For details on the latter
and how to translate between the
two, [see here](https://tljh.jupyter.org/en/latest/topic/authenticator-configuration.html#setting-authenticator-properties)

Note that if you make mistakes, the server may refuse to start as described in this [issue](https://github.com/geospatialcomputing/gisandbox/issues/7)

