# Relight

Relight is the scripts that build the [Vagrant](https://www.vagrantup.com) box for [Phoenix](http://www.phoenixframework.org) application development environment.

You can download the Vagrant box at https://atlas.hashicorp.com/kiaking/boxes/relight.

## Included Software

- Ubuntu 14.04
- Erlang
- Elixir
- Phoenix
- MySQL
- PostgreSQL
- Node (With Gulp)

## Getting Started

To build Relight Vagrant box, just execute `build.sh` scripts.

```shell
$ sh build.sh
```

After executing the script, the `virtualbox.box` file will be created at root of the project folder.

## License

The Relight is open-sourced software licensed under the [MIT license](LICENSE.md).
