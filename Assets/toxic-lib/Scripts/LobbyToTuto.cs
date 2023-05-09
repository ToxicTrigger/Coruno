using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LobbyToTuto : MonoBehaviour
{
    public NetworkTree tree;
    public Lobby lobby;
    // Start is called before the first frame update
    void Start()
    {
        tree = GameObject.FindObjectOfType<NetworkTree>();
        lobby = GameObject.FindObjectOfType<Lobby>();
        tree.isMaster = lobby.isMaster;
        //Destroy(lobby.gameObject);
    }
}
