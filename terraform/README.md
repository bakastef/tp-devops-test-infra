## Repository structure & instructions

The entry point is located in the `env-dev` directory. 
I usually create a `root` dir per environment, define variables and manage my secrets there, and then calling modules locate din the `modules` directory.

I'm using Terraform 0.12+ for HCL2, so please be aware you can't use versions of Terraform < 0.12.0.

For convenience, I've decided to use aws-cli profiles for this test, and have set up teh aws provider to look for credentials in ~/.aws/credentials.
For test/dev purposes, it's the easiest to use and allow to switch environment passing a single string in teh config. 


I generally add the same tag block wherever I can. For clarity: that can help figuring ou easily what is IaC and what is created manually.
For maintenance: that gives the ability to query and/or filter resources via aws-cli, which makes cleanup tasks way easier.

