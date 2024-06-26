# Verifica se o número correto de argumentos foi passado
if [ $# -ne 2 ]; then
    echo "[DAA]: Utilize: $0 <application> <user>"
    exit 1
fi

# Atribui os argumentos às variáveis correspondentes
APP=$1
USER=$2

# Remoção do container
echo "[DAA]: Realizando a remoção do container (se existir).."
docker rm $APP

# Remoção da imagem
echo "[DAA]: Realizando a remoção da imagem (se existir).."
TAGS=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "^$APP")
# Remove cada tag encontrada
for TAG in $TAGS; do
    docker rmi $TAG
done

# Remoção do repositório local
echo "[DAA]: Realizando a remoção do repositório local (se existir)..."
cd ../../
rm -rf $APP

# Remoção do repositório remoto
echo "[DAA]: Realizando a remoção do repositório remoto (se existir)..."
gh auth refresh -h github.com -s delete_repo
gh repo delete $USER/$APP --yes