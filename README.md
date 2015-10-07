Smalltalk AMQP Client based on Apache Qpid Proton
=================================================

The goal of this project is to write a stable and reliable AMQP 1.0 client based on 
[Apache Qpid Proton C API|https://qpid.apache.org/proton/].

Currently I have some working examples for ObjectStudio 7 with a subset of Qpid Proton functionality.
Work for VisualWorks/ObjectStudio8 is in progress.

The client is based on following packages:
- Generator: Generating library wrappers for Smalltalk using Qpid Proton include files
- Qpid-Proton: Base class and generated wrapper classes
- AMQP: Wrappers around the generated Qpid Proton classes which includes some custom functionality
- MQ: Integration into Smalltalk environment for common Messaging patterns. Includes currently a Notification example (AMQP fanout).
- Qpid-Admin: Example how to access REST API for Qpid Java Broker

Work in progress:
- Generating wrappers for VisualWorks
- Moving generator code to VisualWorks
- Setting up an example web site
