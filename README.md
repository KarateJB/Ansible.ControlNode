# Ansible.ControlNode

The project can immediately create a docker container as [Ansible](https://github.com/ansible/ansible) control node to run Ansible playbook.

[Github](https://github.com/KarateJB/Ansible.ControlNode)

[Docker Hub](https://hub.docker.com/repository/docker/karatejb/ansible-control-node)


See [HOW TO USE](#HOW-TO-USE) and following the steps.



***
## HOW TO USE

### 1. PULL DOCKER IMAGE 

```s
$ docker pull karatejb/ansible-control-node:latest
```

For more tags, see [karatejb/ansible-control-node](https://hub.docker.com/repository/docker/karatejb/ansible-control-node).


Before using the container to run your Ansible playbook, you have to

- Prepare your Ansible playbook.
- Set the SSH key on Managed node.


### 2. Run the container

```s
$ docker run -d -it [-v /Demo/Playbooks:/dev/ansible:rw] --name <container_name> karatejb/ansible-control-node:ubuntu1804 bash
```

> Use volume to mounts the playbooks on your docker host into the container in order to run the playbook, it is optional.



For example,

```s
$ docker run -d -it -v /Demo/Playbooks:/dev/ansible:rw --name my-ansible karatejb/ansible-control-node:ubuntu1804 bash
```

For Docker for Windows, run as following,

```s
$ docker run -d -it -v D:\...:/dev/ansible --name ansible-control karatejb/ansible-control-node:ubuntu1804 bash
```



### 3. Set SSH public key to Managed node

The container had already generated a new SSH public & private keys in `~/.ssh/`.


├── id_rsa<br />
├── id_rsa.pub<br />
└── known_hosts<br />




#### 3.1 Get the SSH public key

On docker host, copy the SSH pulic key from Control node, and copy the `authorized_keys` from Managed node. 


- Copy the SSH public key from the Ansible container

```s
$ mkdir tmp
$ docker cp my-ansible:/root/.ssh/id_rsa.pub ./tmp/
```


#### 3.2 Write back to Managed node


Copy the `authorized_keys` from Managed node

```s
$ scp [-P 22] root@<managed_node_ip>:~/.ssh/authorized_keys ./tmp/
```


Update `authorized_keys` with the SSH public key

```s
$ cat tmp/id_rsa.pub >> tmp/authorized_keys
```


Copy back the updated `authorized_keys` to Managed node

```s
$ scp [-P 22] tmp/authorized_keys root@<managed_node_ip>:~/.ssh/authorized_keys
```



***
## APPENDIX

### Build Dockerfile

```s
$ docker build --no-cache  -t ansible-control-node:ubuntu1804 .
```


### Push to Docker Hub

```s
$ docker login
$ docker tag ansible-control-node:ubuntu1804 karatejb/ansible-control-node:ubuntu1804
$ docker push karatejb/ansible-control-node:ubuntu1804
```




### Run the Test playbook

First update the Managed Node's information in `Demo/Playbooks/Test/inventory`.
Assume that the mounted path in container is `/dev/ansible`


```s
$ cd /dev/ansible/Test
$ ansible-playbook --private-key ~/.ssh/id_rsa -i inventory playbook.yml
```



Or run it with `ansible.cfg`,

```
$ ansible-playbook playbook.yml
```

