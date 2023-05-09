using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;


public class NetworkObjectSpawner : MonoBehaviour
{
    public string PrefabName;

    void Start()
    {
        PhotonNetwork.Instantiate(PrefabName, transform.position, transform.rotation);
    }
}
