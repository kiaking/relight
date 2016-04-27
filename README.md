# Relight

Relight is the scripts that build the [Vagrant](https://www.vagrantup.com) box for [Phoenix](http://www.phoenixframework.org) application development environment.

You can download the Vagrant box at https://atlas.hashicorp.com/kiaking/boxes/relight.

## Getting Started

To build Relight Vagrant box, first you need to install `vagrant-reload` plugin.

```shell
$ vagrant plugin install vagrant-reload
```

Then boot up and provision Vagrant and create package.

```shell
$ vagrant up
$ vagrant halt
$ vagrant package --base relight-base
```

After executing above command, the `package.box` file will be created at root of the project folder.

## License

The Relight is open-sourced software licensed under the [MIT license](LICENSE.md).
