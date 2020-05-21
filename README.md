# 42_Ft_services

`ft_services` is an individual school project at [42 Paris](https://www.42.fr) campus.
The purpose of this project is to use Kubernetes to virtualize a network and set a production environment.

## Introduction

<p align="center">
  <img src="assets/Work in progress.gif" alt="demo gif" width="800" />
</p>

For learning purposes only, **not intended for production**.

## Components

* Alpine Linux
* Kubernetes
* Ingress Controller
* Nginx
* FTPS
* WordPress
* phpMyAdmin
* MariaDB (MySQL)
* Grafana
* InfluxDB

### 1 - Linux Alpine

We run our project on Linux Alpine which uses the Linux kernel.  
Alpine Linux is a security-oriented, lightweight Linux distribution based on musl libc and busybox.  
This distribution is particularly suitable, due to its lightness, for the creation of Docker container images.  
[More details here](https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ)

### 2 - Kubernetes and Minikube

Minikube is a tool to facilitate the local execution of Kubernetes. Minikube runs a single-node Kubernetes cluster in a virtual machine (VM) on your laptop.


#### Fonctionnalités de Minikube

## PHP MyAdmin
PhpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web.
It will help to link our databases with the rest ouf our services.

## Wordpress
WordPress (WordPress.org) is a content management system (CMS) based on PHP and MySQL that is usually used with the MySQL or MariaDB database
