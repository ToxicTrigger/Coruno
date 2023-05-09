using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Realtime;
using Photon.Pun;
using ExitGames.Client.Photon;
using UnityEngine.SceneManagement;

public class game_manager : MonoBehaviourPunCallbacks, Photon.Realtime.IOnEventCallback
{
    byte gmEvCode;

    public flag_manager flags;
    public MapObjectManager mapObjectManager;
    public static game_manager instance;
    public Vector3 otherPos;
    public GameObject[] start_points;
    public GameObject start_point;

    public GameObject localPlayer, RemotePlayer;
    public player player;

    public int player_1_hash, player_2_hash;
    public bool is_develop_mode, use_shil;

    public Directions dirPlayer, dirPing;

    public bool SpawnRATO;
    public bool isUpWorld;

    public bool myNearHole;
    public bool otherNearHole;

    public int oriDir = 0;
    public int otherDir;
    public SaveManager saveManager;

    public List<string> DeleteComponentNames;

    public double MyActivePushTime;
    public double otherActivePushTime;
    public bool timeSycBool;

    public Vector2 myPingStartPos;
    public Vector2 myPingEndPos;

    public Vector2 otherPingStartPos;
    public Vector2 otherPingEndPos;

    public Animator UIAni;

    public bool isUsableSwap;
    
    public bool tutorialMaster;
    //Check Sum Layer in Mask!
    public static bool CheckLayer(LayerMask mask, int layer)
    {
         return ((mask & (1<<layer)) != 0);
    }
    void Start()
    {
        saveManager = GetComponent<SaveManager>();
        var all = FindObjectsOfType(typeof(GameObject));
        foreach (var item in all)
        {
            var g = (GameObject)item;
            foreach (var i in DeleteComponentNames)
            {
                var c = g.GetComponent(i);
                if(c != null)
                {
                    Debug.LogWarning(c.gameObject.name + "-" + c.GetType().Name + " is Deleted. isn't using our game.");
                    Destroy(c);
                } 
            }
        }
        gmEvCode = (byte)photonView.ViewID;
        flags = this.GetComponent<flag_manager>();
        mapObjectManager = this.GetComponent<MapObjectManager>();

        if (!is_develop_mode)
        {
            this.start_points = GameObject.FindGameObjectsWithTag("spawnPoint");
            if (PhotonNetwork.IsMasterClient)
            {
                Debug.Log("난 마스터야!");
                Transform target = null;
                foreach (var i in this.start_points)
                {
                    if (i.name.Equals("spawn_1"))
                    {
                        target = i.transform;
                        this.start_point = i.gameObject;
                    }
                }

                localPlayer = PhotonNetwork.Instantiate("PlayerRATO", target.position, Quaternion.identity);
                player = localPlayer.GetComponent<player>();
                localPlayer.GetComponent<player>().is_develop_mode = this.is_develop_mode;
                player_1_hash = localPlayer.name.GetHashCode();
            }
            else
            {
                Debug.Log("난 슬레이브야!");
                Transform target = null;
                foreach (var i in this.start_points)
                {
                    if (i.name.Equals("spawn_2"))
                    {
                        target = i.transform;
                        this.start_point = i.gameObject;
                    }
                }

                localPlayer = PhotonNetwork.Instantiate("PlayerNIHO", target.position, Quaternion.identity);
                player = localPlayer.GetComponent<player>();
                localPlayer.GetComponent<player>().is_develop_mode = this.is_develop_mode;
                player_2_hash = localPlayer.name.GetHashCode();
            }
        }
        else
        {
            if(tutorialMaster)
            {
                this.start_point = this.start_points[0];
                Instantiate(Resources.Load("PlayerRATO"), this.start_point.transform.position, Quaternion.identity);
                this.localPlayer = FindObjectOfType<player>().gameObject;
                player = localPlayer.GetComponent<player>();
                this.localPlayer.GetComponent<player>().is_develop_mode = this.is_develop_mode;
            }
            else
            {
                this.start_point = this.start_points[1];
                Instantiate(Resources.Load("PlayerNIHO"), this.start_point.transform.position, Quaternion.identity);
                this.localPlayer = FindObjectOfType<player>().gameObject;
                player = localPlayer.GetComponent<player>();
                this.localPlayer.GetComponent<player>().is_develop_mode = this.is_develop_mode;
            }
        }
        isUpWorld = this.localPlayer.transform.position.y > 0 ? true : false;

        if (instance == null)
        {
            instance = this;
        }
    }

    private void Update()
    {   
        //GOTO mainLobby
        if(Input.GetKeyDown(KeyCode.O))
        {
            if(PhotonNetwork.PhotonServerSettings.AppSettings.IsDefaultNameServer)
            {
                SceneManager.LoadScene("ReleaseLobby", LoadSceneMode.Single);
                
            }
            else if(player.gameObject.layer == LayerMask.NameToLayer("Player_1"))
            {
                SceneManager.LoadScene("RatoLobby", LoadSceneMode.Single);
            }
            else
            {
                SceneManager.LoadScene("NihoLobby", LoadSceneMode.Single);
            }
        }

        if (this.localPlayer != null)
            this.dirPlayer = localPlayer.transform.GetChild(0).transform.localRotation.eulerAngles.y <= 180 ? Directions.Right : Directions.Left;

        if (oriDir != (int)player.dirMovement)
        {
            oriDir = (int)player.dirMovement;
            PhotonNetwork.RaiseEvent(gmEvCode, (int)player.dirMovement, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        }
    }

    [PunRPC]
    void SendATTime()
    {
        SycActiveButtonTime();
    }
    public void SycActiveButtonTime()
    {
        PhotonNetwork.RaiseEvent(gmEvCode, (double)MyActivePushTime, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
    }

    public IEnumerator KillLocalPlayer()
    {
        var p = localPlayer.GetComponent<player>();
        p.animator.SetBool("Dead", true);
        p.stopInput = true;
        yield return new WaitForSeconds(0.8f);
        UIAni.SetBool("Fade", true);
        p.animator.SetBool("Dead", false);
        yield return new WaitForSeconds(1.2f);
        localPlayer.GetComponent<player>().DieSequence();

        int num = 0;
        if(localPlayer.layer != LayerMask.NameToLayer("Player_1")) num = 1;
        start_point.transform.position = saveManager.savePoints[saveManager.SavePoint].transform.GetChild(num).position;
        localPlayer.transform.position = start_point.transform.position;
        yield return new WaitForSeconds(0.4f);
        p.stopInput = false;
        UIAni.SetBool("Fade", false);
    }

    [PunRPC]
    void Respawn()
    {        
        StartCoroutine(KillLocalPlayer());
    }

    public void RespawnLocalPlayer()
    {
        if(!is_develop_mode) photonView.RPC("Respawn", RpcTarget.All);
        else Respawn();
    }

    public void OnEvent(EventData photonEvent)
    {
        byte evCode = photonEvent.Code;
        if (evCode == gmEvCode)
        {
            if (photonEvent.CustomData is int)
            {
                otherDir = (int)photonEvent.CustomData;
            }
            else if (photonEvent.CustomData is double)
            {
                otherActivePushTime = (double)photonEvent.CustomData;
                timeSycBool = true;
            }
            else if (photonEvent.CustomData is bool)
            {
                otherNearHole = (bool)photonEvent.CustomData;
            }
        }
    }
}


public enum Directions
{
    Idle,
    Right,
    Down,
    Up,
    LeftUp,
    LeftDown,
    RightUp,
    RightDown,
    Dedley,
    Left = -1,
}
