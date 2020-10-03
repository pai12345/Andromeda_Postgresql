function KubeadmInstall() {
    echo "============Kubeadm Installation=============="
    kubeadm reset
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

}

function UpdateSystem() {
    # NAVIGATETODOWNLOADDIRECTORY=$(cd /home/ubuntu/Downloads/Shell)
    # EXECUTEFILE=$(./UpdateSystem.sh)
    NAVIGATETODOWNLOADDIRECTORY=$(cd /home/ubuntu/Downloads/Shell)
    CURRENTDIRECTORY=$(pwd)
    EXECUTEFILE=$(./UpdateSystem.sh)
    echo "System Update Directory: $CURRENTDIRECTORY"
    echo "System Update Progress: $EXECUTEFILE"

}

if [[ $# -eq 0 ]]; then
    echo "==================Kubernetes Automation======================="
    echo "Enter [-k] to Install Kubeadm"
    echo "Enter [-u] to Update System"
    echo "Or"
    echo "Enter -ku to Install Kubeadm and Update System"
    exit 1
fi

if [[ $? -eq 0 ]]; then
    for KEY in "$@"; do
        case "$KEY" in
        -k)
            echo "Installing Kubeadm"
            KubeadmInstall
            ;;
        -u)
            echo "Updating System"
            UpdateSystem
            ;;
        -ku)
            echo "Installing Kubeadm and Updating System"
            KubeadmInstall
            UpdateSystem
            ;;
        *)
            echo "Invalid Flag Detected, please enter [-k] [-u] [-ku]"
            exit 5
            ;;
        esac
    done
fi

