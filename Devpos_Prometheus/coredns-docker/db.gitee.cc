$TTL 3600
$ORIGIN gitee.cc.

@ IN SOA ns1.gitee.cc. gitee.gitee.cc. (
    2020072410 ; Serial
    1H         ; Refresh
    600        ; Retry
    7D         ; Expire
    600        ; Negative Cache TTL
)

@ IN NS ns1

ns1 IN A 192.168.1.60

; Custome
@                 IN A     192.168.1.70
*                 IN CNAME @
kube-apiserver    IN A     192.168.1.71
kube-dashboard    IN CNAME @
hub               IN A     192.168.1.60
files             IN A     192.168.1.60
lfs               IN A     192.168.1.60
files             IN A     192.168.1.60
