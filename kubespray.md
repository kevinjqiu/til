---
title: kubectl
category: Kubernetes
tags: []
updated: 2018-02-16
weight: -10
intro: |
  kubectl tips and tricks
---

Upgrading with kubespray
========================

With kubespray latest as of [Oct 26](https://github.com/kubernetes-incubator/kubespray/commit/ba0a03a8ba2d97a73d06242ec4bb3c7e2012e58c):

`vagrant up` didn't work: `kube-apiserver` did not start

With `v2.2.1` tag. `vagrant up` works with kubernetes `1.7.5`.

Upgrading to 1.8.0

```
ansible-playbook upgrade-cluster.yml -b -i inventory/vagrant_ansible_inventory -e kube_version=v1.8.0
```

```
_________________________________________________________
/ TASK [network_plugin/calico : Calico | Copy cni plugins \\
\\ from hyperkube]                                         /
---------------------------------------------------------
      \\   ^__^
       \\  (oo)\\_______
          (__)\\       )\\/\\
              ||----w |
              ||     ||

Thursday 26 October 2017  12:04:50 -0400 (0:00:00.622)       0:03:59.311 ****** 
FAILED - RETRYING: Calico | Copy cni plugins from hyperkube (4 retries left).
FAILED - RETRYING: Calico | Copy cni plugins from hyperkube (3 retries left).
FAILED - RETRYING: Calico | Copy cni plugins from hyperkube (2 retries left).
FAILED - RETRYING: Calico | Copy cni plugins from hyperkube (1 retries left).
fatal: [alpha-01]: FAILED! => {"attempts": 4, "changed": false, "cmd": ["/usr/bin/docker", "run", "--rm", "-v", "/opt/cni/bin:/cnibindir", "quay.io/coreos/hyperkube:v1.8.0_coreos.0
", "/usr/bin/rsync", "-ac", "/opt/cni/bin/", "/cnibindir/"], "delta": "0:00:00.490754", "end": "2017-10-26 16:05:05.546758", "failed": true, "rc": 127, "start": "2017-10-26 16:05:0
5.056004", "stderr": "container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\"\\n/usr/bin/docker: E
rror response from daemon: oci runtime error: container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directo
ry\\".", "stderr_lines": ["container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\"", "/usr/bin/doc
ker: Error response from daemon: oci runtime error: container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or d
irectory\\"."], "stdout": "", "stdout_lines": []}
```

Error message better formatted:

```
{
"stdout_lines": [],
"stdout": "",
"stderr_lines": [
  "container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\"",
  "/usr/bin/docker: Error response from daemon: oci runtime error: container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\"."
],
"stderr": "container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\"\\n/usr/bin/docker: Error response from daemon: oci runtime error: container_linux.go:247: starting container process caused \\"exec: \\\\\\"/usr/bin/rsync\\\\\\": stat /usr/bin/rsync: no such file or directory\\".",
"attempts": 4,
"changed": false,
"cmd": [
  "/usr/bin/docker",
  "run",
  "--rm",
  "-v",
  "/opt/cni/bin:/cnibindir",
  "quay.io/coreos/hyperkube:v1.8.0_coreos.0",
  "/usr/bin/rsync",
  "-ac",
  "/opt/cni/bin/",
  "/cnibindir/"
],
"delta": "0:00:00.490754",
"end": "2017-10-26 16:05:05.546758",
"failed": true,
"rc": 127,
"start": "2017-10-26 16:05:05.056004"
}
```

so it tries to `rsync` things out of the hyperkube container. Unfrotunately, hyperkube:v1.8.0 no longer ships `rsync`:

```
$ docker run -it quay.io/coreos/hyperkube:v1.8.0_coreos.0 sh -c "find / -name rsync"  # no rsync

$ docker run -it quay.io/coreos/hyperkube:v1.7.5_coreos.0 sh -c "find / -name rsync"
/etc/init.d/rsync
/etc/default/rsync
/usr/share/doc/rsync
/usr/share/lintian/overrides/rsync
/usr/bin/rsync
```

change `rsync` to `cp`:

```
diff --git a/roles/network_plugin/calico/tasks/main.yml b/roles/network_plugin/calico/tasks/main.yml
index aef22ed..21d9f5f 100644
--- a/roles/network_plugin/calico/tasks/main.yml
+++ b/roles/network_plugin/calico/tasks/main.yml
@@ -48,7 +48,7 @@
 changed_when: false

- name: Calico | Copy cni plugins from hyperkube
-  command: "{{ docker_bin_dir }}/docker run --rm -v /opt/cni/bin:/cnibindir {{ hyperkube_image_repo }}:{{ hyperkube_image_tag }} /usr/bin/rsync -ac /opt/cni/bin/ /cnibindir/"
+  command: "{{ docker_bin_dir }}/docker run --rm -v /opt/cni/bin:/cnibindir {{ hyperkube_image_repo }}:{{ hyperkube_image_tag }} /bin/cp -r /opt/cni/bin/. /cnibindir/"
 register: cni_task_result
 until: cni_task_result.rc == 0
 retries: 4
```

Minutes later:
```
alpha-01                   : ok=346  changed=31   unreachable=0    failed=0   
alpha-02                   : ok=319  changed=25   unreachable=0    failed=0   
alpha-03                   : ok=292  changed=18   unreachable=0    failed=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0   

Thursday 26 October 2017  13:28:05 -0400 (0:00:00.038)       0:11:19.723 ****** 
=============================================================================== 
upgrade/pre-upgrade : Drain node -------------------------------------- 102.66s
kubernetes/node : install | Copy kubelet from hyperkube container ------ 56.28s
kubernetes/node : install | Copy kubelet from hyperkube container ------ 43.54s
network_plugin/calico : Calico | Set global as_num ---------------------- 7.82s
bootstrap-os : Bootstrap | Install pip ---------------------------------- 7.42s
kubernetes/master : Master | wait for the apiserver to be running ------- 6.70s
kubernetes/secrets : Check certs | check if a cert already exists on node --- 4.67s
network_plugin/calico : Calico | Set global as_num ---------------------- 4.08s
kubernetes-apps/rotate_tokens : Rotate Tokens | Test if default certificate is expired --- 2.94s
kubernetes/secrets : Check certs | check if a cert already exists on node --- 2.80s
bootstrap-os : Install required python modules -------------------------- 2.23s
network_plugin/calico : Calico | Copy cni plugins from calico/cni container --- 1.95s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down KubeDNS Template --- 1.81s
kubernetes/secrets : Gen_certs | Get certificate serials on kube masters --- 1.81s
kubernetes/node : Write kubelet config file (non-kubeadm) --------------- 1.78s
kubernetes/client : Gather certs for admin kubeconfig ------------------- 1.77s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ------------- 1.61s
vault : include --------------------------------------------------------- 1.54s
vault : sync_file | Combine all possible key file sync sources ---------- 1.51s
kubernetes/node : install | Copy kubelet from hyperkube container ------- 1.43s
```

Do I have 1.8?

```
kubectl get nodes
NAME       STATUS                     AGE       VERSION
alpha-01   Ready,SchedulingDisabled   2h        v1.7.5+coreos.0
alpha-02   Ready                      2h        v1.7.5+coreos.0
alpha-03   Ready                      2h        v1.7.5+coreos.0
```

Nope, still 1.7.5! WTH?

On the hosts:

```
core@alpha-01 ~ $ docker ps
CONTAINER ID        IMAGE                                                                                              COMMAND                  CREATED             STATUS              PORTS               NAMES
09b0764bdf3c        quay.io/calico/node@sha256:3c3e59d02ccda0e1fc28699677c8f8325c0c64f397cb9231307ee230d1b531dd        "start_runit"            19 minutes ago      Up 19 minutes                           k8s_calico-node_calico-node-qkdlq_kube-system_1bbddd0a-ba73-11e7-a94c-080027e7656f_0
0c733ec71a49        gcr.io/google_containers/pause-amd64:3.0                                                           "/pause"                 19 minutes ago      Up 19 minutes                           k8s_POD_calico-node-qkdlq_kube-system_1bbddd0a-ba73-11e7-a94c-080027e7656f_0
b1ac813433ed        quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753   "/hyperkube contro..."   28 minutes ago      Up 28 minutes                           k8s_kube-controller-manager_kube-controller-manager-alpha-01_kube-system_1a4a6f6c170be7f4cbabfa94baec17e7_0
37fbc435e99a        gcr.io/google_containers/pause-amd64:3.0                                                           "/pause"                 28 minutes ago      Up 28 minutes                           k8s_POD_kube-controller-manager-alpha-01_kube-system_1a4a6f6c170be7f4cbabfa94baec17e7_0
77ebdb409fc4        quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753   "/hyperkube schedu..."   28 minutes ago      Up 28 minutes                           k8s_kube-scheduler_kube-scheduler-alpha-01_kube-system_279e27cb9e9258cb1748eb1ee02fb4ed_0
5cac7c56c196        gcr.io/google_containers/pause-amd64:3.0                                                           "/pause"                 28 minutes ago      Up 28 minutes                           k8s_POD_kube-scheduler-alpha-01_kube-system_279e27cb9e9258cb1748eb1ee02fb4ed_0
b95a18e93032        quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753   "/hyperkube apiser..."   28 minutes ago      Up 28 minutes                           k8s_kube-apiserver_kube-apiserver-alpha-01_kube-system_3dee0c90bb657dbdfa08510a4688e744_0
78a0684cfb91        gcr.io/google_containers/pause-amd64:3.0                                                           "/pause"                 28 minutes ago      Up 28 minutes                           k8s_POD_kube-apiserver-alpha-01_kube-system_3dee0c90bb657dbdfa08510a4688e744_0
e0aa1a644632        quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753   "/hyperkube proxy ..."   About an hour ago   Up About an hour                        k8s_kube-proxy_kube-proxy-alpha-01_kube-system_c7a2a01efe6ae68e47faa3a957caf089_0
364e70bab62d        gcr.io/google_containers/pause-amd64:3.0                                                           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-proxy-alpha-01_kube-system_c7a2a01efe6ae68e47faa3a957caf089_0
cca195081509        quay.io/coreos/etcd:v3.2.4                                                                         "/usr/local/bin/etcd"    2 hours ago         Up 2 hours                              etcd1
```

and `quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753` is the v1.8.0 image!

```
$ docker inspect quay.io/coreos/hyperkube:v1.8.0_coreos.0                                                                                                           
[
  {
      "Id": "sha256:6c7699106132c65ef221dbe6a4eb725fd8fa8ad29da08e4a5402c6b4d9cd433e",
      "RepoTags": [
          "quay.io/coreos/hyperkube:v1.8.0_coreos.0"
      ],
      "RepoDigests": [
          "quay.io/coreos/hyperkube@sha256:8755aefadd070df7b26e49ce2998209547eca7bd4054e5dbb434615407374753"
      ],
...
```

See the two hashes match.

`vagrant halt` and `vagrant up`, now it's good:

```
$ kubectl get nodes
NAME       STATUS                     AGE       VERSION
alpha-01   Ready,SchedulingDisabled   3h        v1.8.0+coreos.0
alpha-02   Ready,SchedulingDisabled   3h        v1.8.0+coreos.0
alpha-03   Ready                      3h        v1.8.0+coreos.0
```

During upgrade, running `watch kubectl get cs` and observe if any components fail.

I did get on occasion etcd status became `Unhealthy` with "503".

Trying a separate upgrade from `1.8.0` to `1.8.2`, again, the version reported by `kubectl get nodes` is `1.8.0` after a successful upgrade.

However, going to the node and restarting the kubelet service:

```
$ sudo systemctl restart kubelet.service
```

and now:

```
kubectl get nodes
NAME       STATUS                     AGE       VERSION
alpha-01   Ready,SchedulingDisabled   3h        v1.8.2+coreos.0
alpha-02   Ready,SchedulingDisabled   3h        v1.8.0+coreos.0
alpha-03   Ready                      3h        v1.8.0+coreos.0
```

Upgrading the node should include a step to reload/restart kubelet service.


Finally figured out why the upgrade playbook didn't do that. Fix is PR'ed [here](https://github.com/kubernetes-incubator/kubespray/pull/1889).


Sometimes this happens:
```
TASK [upgrade/pre-upgrade : Drain node] ********************************************************************************************************************************************
Friday 27 October 2017  13:52:27 -0400 (0:00:00.521)       0:01:15.433 ******** 
fatal: [alpha-01 -> None]: FAILED! => {"changed": true, "cmd": ["/opt/bin/kubectl", "drain", "--force", "--ignore-daemonsets", "--grace-period", "90", "--timeout", "120s", "--dele$
e-local-data", "alpha-01"], "delta": "0:02:00.376491", "end": "2017-10-27 17:54:27.680094", "failed": true, "rc": 1, "start": "2017-10-27 17:52:27.303603", "stderr": "WARNING: Ign$
ring DaemonSet-managed pods: calico-node-gbtfk; Deleting pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet: kube-apiserver-alpha-01, kube-contro$
ler-manager-alpha-01, kube-proxy-alpha-01, kube-scheduler-alpha-01\\nWARNING: Ignoring DaemonSet-managed pods: calico-node-gbtfk; Deleting pods not managed by ReplicationController$
ReplicaSet, Job, DaemonSet or StatefulSet: kube-apiserver-alpha-01, kube-controller-manager-alpha-01, kube-proxy-alpha-01, kube-scheduler-alpha-01\\nThere are pending pods when an 
error occurred: Drain did not complete within 2m0s\\npod/kube-dns-3888408129-d65l4\\nerror: Drain did not complete within 2m0s", "stderr_lines": ["WARNING: Ignoring DaemonSet-manage$
pods: calico-node-gbtfk; Deleting pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet: kube-apiserver-alpha-01, kube-controller-manager-alpha-01, 
kube-proxy-alpha-01, kube-scheduler-alpha-01", "WARNING: Ignoring DaemonSet-managed pods: calico-node-gbtfk; Deleting pods not managed by ReplicationController, ReplicaSet, Job, D$
emonSet or StatefulSet: kube-apiserver-alpha-01, kube-controller-manager-alpha-01, kube-proxy-alpha-01, kube-scheduler-alpha-01", "There are pending pods when an error occurred: D$
ain did not complete within 2m0s", "pod/kube-dns-3888408129-d65l4", "error: Drain did not complete within 2m0s"], "stdout": "node \\"alpha-01\\" already cordoned", "stdout_lines": [$
node \\"alpha-01\\" already cordoned"]}
      to retry, use: --limit @/home/kevin.qiu/src/kubespray/upgrade-cluster.retry
```

> Drain did not complete within 2m0s

Tweak the `drain_timeout` parameter.

Upgrade etcd
============

Modify the `etcd_version` parameter, like so:

```
ansible-playbook upgrade-cluster.yml -b -i inventory/vagrant_ansible_inventory -e kube_version=v1.8.2 -e etcd_version=v3.2.9
```

Uprade is a success


Upgrade with stateful services
==============================

Install consul:

```
helm install -f values.yaml stable/consul
```

Consul needs pvs. For vagrant, we need to create a couple of PVs (no dynamic PV):

```
---
apiVersion: v1
kind: PersistentVolume
metadata:
name: pv0001
spec:
capacity:
  storage: 2Gi
accessModes:
  - ReadWriteOnce
persistentVolumeReclaimPolicy: Recycle
storageClassName: ""
hostPath:
  path: "/tmp/data1"
---
apiVersion: v1
kind: PersistentVolume
metadata:
name: pv0002
spec:
capacity:
  storage: 2Gi
accessModes:
  - ReadWriteOnce
persistentVolumeReclaimPolicy: Recycle
storageClassName: ""
hostPath:
  path: "/tmp/data2"
---
apiVersion: v1
kind: PersistentVolume
metadata:
name: pv0003
spec:
capacity:
  storage: 2Gi
accessModes:
  - ReadWriteOnce
persistentVolumeReclaimPolicy: Recycle
storageClassName: ""
hostPath:
  path: "/tmp/data3"
```

The pods should be up.

```
kubectl get po -w
```

and run the upgrade.

Upgrading onprem
================

Use points-alpha cluster as test bed.

Write script to check ingress health during an upgrade process:

```
import requests
import time
import sys
import datetime


def main():
  failed = []
  try:
      while True:
          time.sleep(0.5) 
          response = requests.get('https://prometheus-k8s.alpha.points.com/metrics') 
          if response.status_code == 200:
              sys.stdout.write('.')
          else:
              sys.stdout.write('X')
              failed.append((datetime.datetime.now(), response))
          sys.stdout.flush()
  except KeyboardInterrupt:
      import pdb
      pdb.set_trace()


if __name__ == '__main__':
  main()
```

First, kubespray with the existing configuration. This *should* result in a no-op, however, this broke etcd:

```
fatal: [etc1.k8s.points.com]: FAILED! => {"attempts": 10, "changed": false, "content": "", "failed": true, "msg": "Status code was not [200]: Request failed: <urlopen error [Errno 
111] Connection refused>", "redirected": false, "status": -1, "url": "https://10.70.180.35:2379/health"}
fatal: [etc5.k8s.points.com]: FAILED! => {"attempts": 10, "changed": false, "content": "", "failed": true, "msg": "Status code was not [200]: Request failed: <urlopen error [Errno 
111] Connection refused>", "redirected": false, "status": -1, "url": "https://10.70.180.39:2379/health"}
fatal: [etc3.k8s.points.com]: FAILED! => {"attempts": 10, "changed": false, "content": "", "failed": true, "msg": "Status code was not [200]: Request failed: <urlopen error [Errno 
111] Connection refused>", "redirected": false, "status": -1, "url": "https://10.70.180.37:2379/health"}
__________________________________________________
< RUNNING HANDLER [etcd : set etcd_secret_changed] >
--------------------------------------------------
      \\   ^__^
       \\  (oo)\\_______
          (__)\\       )\\/\\
              ||----w |
              ||     ||

      to retry, use: --limit @/home/kevin.qiu/src/cloud/kubernetes/kubespray/kubespray/cluster.retry
____________
< PLAY RECAP >
------------
      \\   ^__^
       \\  (oo)\\_______
          (__)\\       )\\/\\
              ||----w |
              ||     ||

c1.k8s.points.com          : ok=79   changed=7    unreachable=0    failed=0   
c3.k8s.points.com          : ok=79   changed=7    unreachable=0    failed=0   
c5.k8s.points.com          : ok=79   changed=7    unreachable=0    failed=0   
etc1.k8s.points.com        : ok=126  changed=21   unreachable=0    failed=1   
etc3.k8s.points.com        : ok=122  changed=24   unreachable=0    failed=1   
etc5.k8s.points.com        : ok=122  changed=24   unreachable=0    failed=1   
localhost                  : ok=3    changed=0    unreachable=0    failed=0   
m1.k8s.points.com          : ok=80   changed=7    unreachable=0    failed=0   
m3.k8s.points.com          : ok=79   changed=7    unreachable=0    failed=0   
m5.k8s.points.com          : ok=79   changed=7    unreachable=0    failed=0   

$ kubectl get cs
NAME                 STATUS      MESSAGE                                                                                            ERROR
etcd-2               Unhealthy   Get https://10.70.180.35:2379/health: dial tcp 10.70.180.35:2379: getsockopt: connection refused   
etcd-1               Unhealthy   Get https://10.70.180.39:2379/health: dial tcp 10.70.180.39:2379: getsockopt: connection refused   
scheduler            Healthy     ok                                                                                                 
etcd-0               Unhealthy   Get https://10.70.180.37:2379/health: dial tcp 10.70.180.37:2379: getsockopt: connection refused   
controller-manager   Healthy     ok                                                                                                 

```

on node etc1:

```
2017-10-30 19:39:24.736045 I | etcdserver: data dir = /var/lib/etcd
2017-10-30 19:39:24.736054 I | etcdserver: member dir = /var/lib/etcd/member
2017-10-30 19:39:24.736061 I | etcdserver: heartbeat = 250ms
2017-10-30 19:39:24.736067 I | etcdserver: election = 5000ms
2017-10-30 19:39:24.736073 I | etcdserver: snapshot count = 10000
2017-10-30 19:39:24.736087 I | etcdserver: advertise client URLs = https://10.70.180.35:2379
2017-10-30 19:39:24.736212 W | wal: ignored file 0000000000000011-00000000000763f7.wal.broken in wal
2017-10-30 19:39:24.736228 W | wal: ignored file 0000000000000032-000000000015c8d5.wal.broken in wal
2017-10-30 19:39:25.076519 I | etcdserver: restarting member cf6fced7f4438d71 in cluster 686414454e06e76c at commit index 3524099
2017-10-30 19:39:25.079041 I | raft: cf6fced7f4438d71 became follower at term 135
2017-10-30 19:39:25.079116 I | raft: newRaft cf6fced7f4438d71 [peers: [7ae22e3d626bd040,9a880aa389201c5e,cf6fced7f4438d71], term: 135, commit: 3524099, applied: 3500039, lastindex: 3524100, lastterm: 135]
2017-10-30 19:39:25.079430 C | membership: cluster cannot be downgraded (current version: 3.0.17 is lower than determined cluster version: 3.2).

```

Checking the `inventory/group_vars/overrides-onprem-alpha.yaml`, the file seems to be outdated or the cluster was not sprayed with that file. e.g., `authorization_modes` is set to RBAC but the cluster doesn't have RBAC enabled. Also, kube_version is v1.6.7 in the overrides file, but the real cluster version is 1.7.5

Pinned version of etcd to v3.2 in the values override file. Respray:

```
c1.k8s.points.com          : ok=292  changed=30   unreachable=0    failed=0   
c3.k8s.points.com          : ok=271  changed=24   unreachable=0    failed=0   
c5.k8s.points.com          : ok=273  changed=25   unreachable=0    failed=0   
etc1.k8s.points.com        : ok=132  changed=17   unreachable=0    failed=0   
etc3.k8s.points.com        : ok=128  changed=20   unreachable=0    failed=0   
etc5.k8s.points.com        : ok=128  changed=20   unreachable=0    failed=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0   
m1.k8s.points.com          : ok=333  changed=36   unreachable=0    failed=0   
m3.k8s.points.com          : ok=299  changed=32   unreachable=0    failed=1   
m5.k8s.points.com          : ok=310  changed=37   unreachable=0    failed=0   
```

Everything seemed to go wonky. The cluster seems to be in an ok-ish state, but nginx frontend is reporting `502 Bad Gateway`.
