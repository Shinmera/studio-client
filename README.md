## About Studio-Client
This is a common lisp client library for the [Studio](https://github.com/Shirakumo/studio) image gallery hosting software.

## How To
Note that this requires the [r-oauth](https://github.com/Shirakumo/radiance-contribs/tree/master/r-oauth) module to be present on the Radiance instance Studio is hosted on. You will also need to create an oAuth application on the Radiance instance to authenticate through. On the default TyNET instance, this can be done in the [admin panel](http://admin.tymoon.eu/oauth/applications).

Create your application and load up Studio-Client, including the [North](https://shinmera.github.io/north) backend of your choice.

    (ql:quickload '(studio-client north-drakma))

Once armed with an application key and secret, you can create a `client` instance:

    (defvar *client* (make-instance 'studio-client:client 
                       :api-base <API-URL>
                       :key <KEY>
                       :secret <SECRET>))

On the default TyNET instance the `api-base` would be `"https://studio.tymoon.eu/api/"`. Once a client has been created, start the oAuth flow with `north:initiate-authentication` and visit the URL it returns.

    (north:initiate-authentication *client*)
    ; => https://studio.tymoon.eu/api/oauth/authorize....

Once you have authorised the application on the page, copy the code it gives you and pass it to `north:complete-authentication`

    (north:complete-authentication *client* "3D6E639C-A0A8-...")

If this succeeds you should be ready to query the Studio API without any problems.

    (studio-client:galleries *client*)
    ; => (#<STUDIO-CLIENT:GALLERY shinmera #1> #<STUDIO-CLIENT:GALLERY anon #11> ...)
    (studio-client:uploads *client* (first *))
    ; => (#<STUDIO-CLIENT:UPLOAD "I know everything" #1286> ...)
    (studio-client:file-url *client* (first (studio-client:files (first *))))
    ; => http://studio.tymoon.eu/api/studio/file?id=1365

See the two primary objects `gallery` and `upload` for more information.
