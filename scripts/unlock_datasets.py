#!/usr/bin/env python3

# NOTE this script cannot be executed on its own
# this gets called by `unlock_dataset.sh`

import urllib.request
import os
import sys
import json

list_of_datasets = ["tank/encr"]

if len(sys.argv) == 1:
    print("need truenas_passphrase")
    sys.exit(1)

truenas_passphrase = sys.argv[1]

host = "localhost"
token = os.environ.get("TRUENAS_API_TOKEN")

unlock_dataset_endpoint = "/api/v2.0/pool/dataset/unlock"

unlock_dataset_url = "http://{host}{unlock_dataset_endpoint}".format(
    host=host, unlock_dataset_endpoint=unlock_dataset_endpoint
)

for id in list_of_datasets:
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer {token}".format(token=token),
    }

    post_data = {
        "id": id,
        "unlock_options": {
            "key_file": False,
            "recursive": False,
            "datasets": [{"name": id, "passphrase": truenas_passphrase}],
        },
    }
    post_data_bytes = json.dumps(post_data).encode("utf-8")

    req = urllib.request.Request(
        unlock_dataset_url,
        method="POST",
        data=post_data_bytes,
        headers=headers,
    )

    resp = urllib.request.urlopen(req)
    content = resp.read()
    print(content)
    resp.close()
