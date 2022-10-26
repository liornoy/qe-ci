metallb_path="/home/lnoy/go/src/github.com/liornoy/metallb"
echo "Starting clean up script"
docker rm -f ibgp-single-hop ibgp-multi-hop ebgp-single-hop ebgp-multi-hop
rm -rf ${metallb_path}/e2etest/ibgp-single-hop ${metallb_path}/e2etest/ibgp-multi-hop ${metallb_path}/e2etest/ebgp-single-hop ${metallb_path}/e2etest/ebgp-multi-hop
docker network remove multi-hop-net
