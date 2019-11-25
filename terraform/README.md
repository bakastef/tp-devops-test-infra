## Repository structure & instructions

The entry point is located in the `env-dev` directory. 
I usually create a `root` directory per environment, define variables and manage my secrets there. I then use re-uable modules -- locatedin the `modules` directory -- to actually do teh job and build resources.


`NOTES`

I'm using Terraform 0.12.16 for HCL2, so please be aware you need compatible a version of Terraform. (0.12+)

For convenience, I've decided to use aws-cli profiles for this test, and have set up teh aws provider to look for credentials in ~/.aws/credentials.
For test/dev purposes, it's the easiest to use and allow to switch environment passing a single string in teh config. 


I generally add the same tag block wherever I is possible and on every ceated resource. 
It helps with clarity: that can help figuring out easily what is IaC and what is created manually.
Also for maintenance: that gives the ability to query and/or filter resources via aws-cli, which makes cleanup tasks way easier.

Because this is a public repository, I have removed all mention of the company it is for ;) 
