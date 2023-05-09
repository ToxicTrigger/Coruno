using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

[RequireComponent(typeof(Collider2D))]
public class NetworkTree : MonoBehaviourPunCallbacks
{
    private byte maxPlayersPerRoom = 2;
    public bool hasConnectedMaster;
    string gameVersion = "1";
    public string roomName;
    public string sceneLoadName;
    public bool isMaster;

    public GameObject aa;
    public GameObject WaitUIback, WaitUIFront, Spning;
    public Animation ghostAni;
    // Start is called before the first frame updat

    private void Awake()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
    }

    void Start()
    {
        PhotonNetwork.GameVersion = gameVersion;
        roomName = "Last";
        aa = GameObject.FindObjectOfType<LobbyToTuto>().gameObject;
        
    }

    // Update is called once per frame
    void Update()
    {
        if(PhotonNetwork.CurrentRoom != null)
        {
            Debug.Log("방이당");
            Debug.Log(PhotonNetwork.CurrentRoom.Name);
        }
        if (!PhotonNetwork.IsConnected)
        {
            PhotonNetwork.ConnectUsingSettings();
        }

        if (Input.GetKeyDown(KeyCode.B))
        {   
            PhotonNetwork.JoinRoom(roomName);
        }
    }

    public void Connect()
    {      
        PhotonNetwork.ConnectUsingSettings();
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.transform.CompareTag("Player"))
        {
            changeNetworkMode();
            StartCoroutine(ConnectNetworkTree());
        }
    }


    public void JoinRoom()
    {
        Debug.Log("JoinRoom()");
        Debug.Log(PhotonNetwork.NetworkClientState);
        if (!PhotonNetwork.InRoom && PhotonNetwork.NetworkClientState == ClientState.ConnectedToMasterServer)
        {
            PhotonNetwork.JoinRoom(roomName);
        }
    }

    public override void OnJoinRoomFailed(short returnCode, string message)
    {
        Debug.Log("들어갈꼬임");
        base.OnJoinRoomFailed(returnCode, message);
        
    }

    public override void OnCreatedRoom()
    {     
        base.OnCreatedRoom();
        Debug.Log("방만들었츰");
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        base.OnPlayerEnteredRoom(newPlayer);
    }

    public override void OnJoinedRoom()
    {
        base.OnJoinedRoom();
        CancelInvoke();
        if(!PhotonNetwork.IsMasterClient)
        {
            photonView.RPC("startGameRoutine", RpcTarget.All);
        }
    }

    [PunRPC]
    public void startGameRoutine()
    {
        StartCoroutine(ChangePlayScene());
    }

    public void LoadScene()
    {
        PhotonNetwork.LoadLevel(this.sceneLoadName);
    }

    void changeNetworkMode()
    {
        //    

        //나무 만지면 할거
        StartCoroutine(treeScene());
        //


        game_manager.instance.is_develop_mode = false;
        game_manager.instance.flags.flags["OtherSwapRequest"] = false;
    }

    IEnumerator treeScene()
    {
        game_manager.instance.player.stopInput = true;
        game_manager.instance.player.rig.velocity = Vector3.zero;
        yield return new WaitForSeconds(0.5f);
        float time = 0;
        while (time <= 1.7f)
        {
            time += Time.deltaTime;
            game_manager.instance.player.rig.velocity = Vector3.right * 3;
            yield return new WaitForEndOfFrame();
        }
        game_manager.instance.player.animator.SetInteger("Event", 4);
        WaitUIback.SetActive(true);
        WaitUIFront.SetActive(true);
        Spning.SetActive(true);

        StartCoroutine(FadeIn(WaitUIback, 0.8f));
        StartCoroutine(FadeIn(WaitUIFront, 1));
        StartCoroutine(FadeIn(Spning, 1));
    }

    IEnumerator ConnectNetworkTree()
    {
        
        yield return new WaitUntil(() => hasConnectedMaster == true);
        if(isMaster)
        {
            PhotonNetwork.CreateRoom(roomName);
        }
        else
        {
            InvokeRepeating("JoinRoom", 0, 0.5f);
        }
    }

    IEnumerator ChangePlayScene()
    {
        /*
        여기다 씬전환 해야할것
        */
        ghostAni.Play("Ghost_Network");
        yield return new WaitUntil(() => !ghostAni.isPlaying);

        if (PhotonNetwork.IsMasterClient)
        {
            LoadScene();
        }
        yield return null;
    }

    public override void OnConnectedToMaster()
    {
        base.OnConnectedToMaster();
        hasConnectedMaster = true;
    }

    IEnumerator FadeIn(GameObject obj, float a)
    {
        SpriteRenderer sr = obj.GetComponent<SpriteRenderer>();
        TextMesh tm = obj.GetComponent<TextMesh>();

        if (sr != null)
        {
            Color srColor = sr.color;
            while (true)
            {
                srColor.a += 0.01f;
                sr.color = srColor;
                if (sr.color.a >= a) break;
                yield return new WaitForSeconds(0.01f);
            }
        }

        if (tm != null)
        {
            Color tmColor = tm.color;
            while (true)
            {
                tmColor.a += 0.01f;
                tm.color = tmColor;
                if (tm.color.a >= a) break;
                yield return new WaitForSeconds(0.01f);
            }
        }
    }
}
