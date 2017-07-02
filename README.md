# Iris

A self hosted notification server without google cloud messaging or firebase cloud messaging.

## Motivation
The driving force behind this project is my need of a tool that:
- Notifies the user when something is happening in a service/application.
- The user can deploy it in hes/her premises.
- Use a self hosted and open source message broker and not an external one.

## Project Status

[![Build Status](https://api.travis-ci.org/JosKar/iris_server.svg?branch=master)](https://travis-ci.org/JosKar/iris_server)
[![Coverage Status](https://coveralls.io/repos/github/JosKar/iris_server/badge.svg?branch=master)](https://coveralls.io/github/JosKar/iris_server?branch=master)

This project is under development, it is not ready for production use yet.

## Usage example

```
TODO Quick example
```

### Prerequisites
  TODO

## Installation

### Installing via DEB package
  TODO

### Installing via docker image
  TODO

## Roadmap

Version 0.1
- [ ] Implement basic API (Services, Subscriptions, Messaging).
- [ ] Implement the bare minimum UI.
- [ ] Implement communication with emqtt.
- [ ] Implement basic authentication.
- [ ] Create deb package for easy installation.
- [ ] Create a bare minimum Android application.

Version 0.2
- [ ] Applications as plugins.
- [ ] Create some default applications eg. fail2ban, pam-sshd, paypal.

## Built With

* [Phoenix](https://github.com/phoenixframework/phoenix)
* [Hulaaki](https://github.com/suvash/hulaaki)
* [Emqttd](https://github.com/emqtt/emqttd)
* [Bootstrap](https://github.com/twbs/bootstrap)
* [Bootswatch](https://github.com/thomaspark/bootswatch)

## Naming
Iris in Greek mythology was one of the messengers of the Olympian gods.

## Authors

* Stelios Joseph Karras

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details

## Acknowledgments

* Inspired by [pushbullet](pushbullet.com), [pushover](pushover.net) and [pushjet](pushjet.io)
