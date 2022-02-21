This Docker Image is based on [m365pnp/spfx](https://hub.docker.com/r/m365pnp/spfx), but with the Alpine Version (70% smaller size) and includes the npm package [spfx-fast-serve](https://github.com/s-KaiNet/spfx-fast-serve)

# Usage

1. Create a folder for your SharePoint Framework project

## on macOS
In the command line enter this:

```bash
cd path_to_your_project
docker run -it --rm --name ${PWD##*/} -v $PWD:/usr/app/spfx -p 4321:4321 -p 35729:35729 seryoga/spfx
```

## on Windows
In PowerShell command line enter this:

```bash
cd path_to_your_project
docker run -it --rm --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 4321:4321 -p 35729:35729 seryoga/spfx
```

## After the container started
After the container started you can work with it the same way you would work with SharePoint Framework installed on your host. To create a new SharePoint Framework project in the container command line execute:

```bash
yo @microsoft/sharepoint
```

All files scaffolded by the generator will be stored in your project directory on your host from where you can commit them to source control.

## Serve
If you run `gulp serve` or `npm run serve` (provided it has been deployed, see chapter SPFx Fast Serve), your component will not be displayed (in SharePoint). The reason is, that the certificate is not trusted. It does not matter if you have already run `gulp trust-dev-cert` on your local environment or if you did it in the container. To view the SPFx component, you must go to the URL `https://localhost:4321` (on the local environment). After that, you have to trust the certificate.

## SPFx Fast Serve
To use the npm package [spfx-fast-serve](https://github.com/s-KaiNet/spfx-fast-serve) in your container, you just have to open `fast-serve/webpack.extend.js` and adjust the constant `webpackConfig`:


```javascript
const webpackConfig = {
  devServer: {
    host: '0.0.0.0',
    publicPath: 'https://0.0.0.0:4321/dist/',
    sockHost: 'localhost',
    watchOptions: {
      aggregateTimeout: 500, // delay before reloading
      poll: 1000 // enable polling since fsevents are not supported in docker
    }
  },
  output: {
    publicPath: 'https://0.0.0.0:4321/dist/'
  }
}
``` 

Now the `npm run serve` command also works in the container.

## Close container
To close the container in the container command line run:

```bash
exit
```

## Known issues

See original image: https://hub.docker.com/r/m365pnp/spfx

## Additional Notes
If you want to understand how it works and what I did, read through this [blogpost](https://spfx-app.dev/how-docker-containers-eliminate-spfx-environment-setup)
