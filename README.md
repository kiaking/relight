# Relight

Relight is the scripts that build the [Vagrant](https://www.vagrantup.com) box for [Phoenix](http://www.phoenixframework.org) application development environment.

You can download the Vagrant box at https://atlas.hashicorp.com/kiaking/boxes/relight.

## Included Software

- Ubuntu 14.04
- Erlang v18.3
- Elixir v1.3.1
- Phoenix v1.2.0
- MariaDB v10.1.6
- PostgreSQL v9.5.3
- Node v6.1.3 (With Gulp)

## To Build Vagrant Box 

To build Relight Vagrant box, just execute `build.sh` scripts.

```shell
$ sh build.sh
```

After executing the script, the `virtualbox.box` file will be created at root of the project folder.

## License

The Relight is open-sourced software licensed under the [MIT license](LICENSE.md).
