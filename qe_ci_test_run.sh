# run metallb e2e tests with existing docker containers.
echo "Starting setup for testing ibgp-single-hop container"

frr_image="frr:v7.5.1"
metallb_path="/home/lnoy/go/src/github.com/liornoy/metallb"
SKIP="IPV6|DUALSTACK|metrics"
script_path=${PWD}

cp -r ibgp-single-hop ${metallb_path}/e2etest
cd ${metallb_path}
docker run -d --privileged  --name ibgp-single-hop --network kind --rm -v ${PWD}/e2etest/ibgp-single-hop/:/etc/frr frrouting/${frr_image}
export USE_IBGP_SINGLE_HOP=true
invoke e2etest

echo "Starting setup for testing multi-hop scenrio"
cd ${script_path}
cp -r ebgp-single-hop ${metallb_path}/e2etest
cp -r ebgp-multi-hop ${metallb_path}/e2etest
cp -r ibgp-multi-hop ${metallb_path}/e2etest

cd ${metallb_path}
# Set up the multi-hop-net. This will differ in the real qe ci.
docker network create multi-hop-net --ipv6 --driver=bridge --subnet=172.30.0.0/16 --subnet=fc00:f853:ccd:e798::/64

docker run -d --privileged  --name ebgp-single-hop --network kind --rm -v ${PWD}/e2etest/ebgp-single-hop/:/etc/frr frrouting/${frr_image}
docker run -d --privileged  --name ebgp-multi-hop --network multi-hop-net --rm -v ${PWD}/e2etest/ebgp-multi-hop/:/etc/frr frrouting/${frr_image}
docker run -d --privileged  --name ibgp-multi-hop --network multi-hop-net --rm -v ${PWD}/e2etest/ibgp-multi-hop/:/etc/frr frrouting/${frr_image}


unset USE_IBGP_SINGLE_HOP
export USE_EBGP_SINGLE_HOP=true
export USE_EBGP_MULTI_HOP=true
export USE_IBGP_MULTI_HOP=true
invoke e2etest
