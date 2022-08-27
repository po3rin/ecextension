NAME=sample_dict
ID=`ecctl deployment extension list | jq --arg name $NAME '.extensions[] | select(.name == $name)' | jq .id -r`

if [ -z "$ID" ]; then
	echo "create new extension: ${NAME}"
	ecctl deployment extension create $NAME --type=bundle --version='*' --file=sample.zip --description=テスト用ユーザー辞書 
else
	echo "update extension: ${NAME}"
	ecctl deployment extension update $ID --generate-payload > payload_for_update.json
	ecctl deployment extension update $ID --extension-file=sample.zip --file=payload_for_update.json 
	rm payload_for_update.json

	curl -XGET \
	-H "Authorization: ApiKey $EC_API_KEY" \
	"https://api.elastic-cloud.com/api/v1/deployments" | jq .
fi

echo 'done :)'
