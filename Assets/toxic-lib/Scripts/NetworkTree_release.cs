using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

[RequireComponent(typeof(Collider2D))]
public class NetworkTree_release : MonoBehaviourPunCallbacks
{
    enum UIState
    {
        None,
        SelectWindow,
        CreateRoom,
        JoinRoom
    }
    UIState uiState = UIState.None;
    private byte maxPlayersPerRoom = 2;
    public bool hasConnectedMaster;
    string gameVersion = "1";
    public string roomName;
    public string sceneLoadName;
    public int inputRoomNum = 0;
    bool isInitInputNum;
    bool isFullInputNum;
    bool inCreateRoom;
    public GameObject aa;
    public GameObject WaitUIback, WaitUIFront, roomNum, CreateUI, JoinUI, FlyCr, FlyJo ,SelectChoose , NumFrame, Enter, friend;
    public Sprite Create, Join, highCreateUI, highJoinUI;
    public Animation ghostAni;

    bool isRoomInput;
    // Start is called before the first frame updat

    private void Awake()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
    }

    void Start()
    {
        inCreateRoom = true;
        PhotonNetwork.GameVersion = gameVersion;
        aa = GameObject.FindObjectOfType<LobbyToTuto>().gameObject;
    }

    // Update is called once per frame
    void Update()
    {
      
        if (PhotonNetwork.CurrentRoom != null)
        {
            Debug.Log("방이당");
            Debug.Log(PhotonNetwork.CurrentRoom.Name);
            roomName = PhotonNetwork.CurrentRoom.Name;
            roomNum.GetComponent<TextMesh>().text = PhotonNetwork.CurrentRoom.Name;
        }
        if (!PhotonNetwork.IsConnected)
        {
            PhotonNetwork.ConnectUsingSettings();
        }

        switch (uiState)
        {
            case UIState.SelectWindow :
                SelectWindow();
                break;
            case UIState.CreateRoom:
                if (PhotonNetwork.CurrentRoom != null)
                    roomNum.GetComponent<TextMesh>().text = PhotonNetwork.CurrentRoom.Name;
                break;
            case UIState.JoinRoom:
                RoomInput();
                break;
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
        }
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {        
        base.OnCreateRoomFailed(returnCode, message);
        PhotonNetwork.CreateRoom(Random.Range(1000, 9999).ToString());
    }

    public override void OnJoinRoomFailed(short returnCode, string message)
    {
        Debug.Log("실패함");
        base.OnJoinRoomFailed(returnCode, message);
        
    }

    public override void OnCreatedRoom()
    {     
        base.OnCreatedRoom();
        Debug.Log("방만들었츰");
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
        ChangeWindow(UIState.SelectWindow);
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

    IEnumerator FadeIn(GameObject obj, float a, bool INOUT)
    {
        SpriteRenderer sr = obj.GetComponent<SpriteRenderer>();
        TextMesh tm = obj.GetComponent<TextMesh>();
        if(uiState == UIState.CreateRoom)
        {
            yield return new WaitUntil(() => PhotonNetwork.CurrentRoom != null);
        }
        if (INOUT)
        {
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
        else
        {
            if (sr != null)
            {
                Color srColor = sr.color;
                while (true)
                {
                    srColor.a -= 0.01f;
                    sr.color = srColor;
                    if (sr.color.a <= a) break;
                    yield return new WaitForSeconds(0.01f);
                }
            }

            if (tm != null)
            {
                Color tmColor = tm.color;
                while (true)
                {
                    tmColor.a -= 0.01f;
                    tm.color = tmColor;
                    if (tm.color.a <= a) break;
                    yield return new WaitForSeconds(0.01f);
                }
            }
        }
    }

    void SelectWindow()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow)) inCreateRoom = true;
        else if (Input.GetKeyDown(KeyCode.RightArrow)) inCreateRoom = false;

        if (inCreateRoom)
        {
            FlyJo.SetActive(false);
            FlyCr.SetActive(true);
            CreateUI.GetComponent<SpriteRenderer>().sprite = highCreateUI;
            JoinUI.GetComponent<SpriteRenderer>().sprite = Join;
        }
        else
        {
            FlyCr.SetActive(false);
            FlyJo.SetActive(true);
            CreateUI.GetComponent<SpriteRenderer>().sprite = Create;
            JoinUI.GetComponent<SpriteRenderer>().sprite = highJoinUI;
        }
        if(Input.GetKeyDown(KeyCode.Return)|| Input.GetKeyDown(KeyCode.KeypadEnter))
        {
            if(inCreateRoom)
            {
                PhotonNetwork.CreateRoom(Random.Range(1000, 9999).ToString());
                ChangeWindow(UIState.CreateRoom);
            }
            else
            {
                ChangeWindow(UIState.JoinRoom);
            }
        }
    }

    void RoomInput()
    {
        if (inputRoomNum >= 1000 || inputRoomNum == 0) isFullInputNum = true;
        else isFullInputNum = false;
        if (Input.GetKeyDown(KeyCode.Alpha0) || Input.GetKeyDown(KeyCode.Keypad0))
        {
            isInitInputNum = true;
            int num = 0;
            if(isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha1) || Input.GetKeyDown(KeyCode.Keypad1))
        {
            isInitInputNum = true;
            int num = 1;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2) || Input.GetKeyDown(KeyCode.Keypad2))
        {
            isInitInputNum = true;
            int num = 2;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3) || Input.GetKeyDown(KeyCode.Keypad3))
        {
            isInitInputNum = true;
            int num = 3;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha4) || Input.GetKeyDown(KeyCode.Keypad4))
        {
            isInitInputNum = true;
            int num = 4;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha5) || Input.GetKeyDown(KeyCode.Keypad5))
        {
            isInitInputNum = true;
            int num = 5;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha6) || Input.GetKeyDown(KeyCode.Keypad6))
        {
            isInitInputNum = true;
            int num = 6;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha7) || Input.GetKeyDown(KeyCode.Keypad7))
        {
            isInitInputNum = true;
            int num = 7;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha8) || Input.GetKeyDown(KeyCode.Keypad8))
        {
            isInitInputNum = true;
            int num = 8;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha9) || Input.GetKeyDown(KeyCode.Keypad9))
        {
            isInitInputNum = true;
            int num = 9;
            if (isFullInputNum)
            {
                inputRoomNum = num;
            }
            else
            {
                inputRoomNum *= 10;
                inputRoomNum += num;
            }
        }
        else if(Input.GetKeyDown(KeyCode.KeypadEnter) || Input.GetKeyDown(KeyCode.Return))
        {
            PhotonNetwork.JoinRoom(inputRoomNum.ToString());
        }
        if (isInitInputNum) roomNum.GetComponent<TextMesh>().text = inputRoomNum.ToString();
    }

    void ChangeWindow(UIState State)
    {
        switch (State)
        {
            case UIState.SelectWindow:
                uiState = UIState.SelectWindow;
                WaitUIback.SetActive(true);
                WaitUIFront.SetActive(true);
                CreateUI.SetActive(true);
                JoinUI.SetActive(true);
                SelectChoose.SetActive(true);

                StartCoroutine(FadeIn(WaitUIback, 0.9f, true));
                StartCoroutine(FadeIn(WaitUIFront, 1f, true));
                StartCoroutine(FadeIn(CreateUI, 1f, true));
                StartCoroutine(FadeIn(JoinUI, 1f, true));
                StartCoroutine(FadeIn(SelectChoose, 1f, true));                           
                break;
            case UIState.CreateRoom:
                uiState = UIState.CreateRoom;
                StartCoroutine(FadeIn(WaitUIFront, 0f, false));
                StartCoroutine(FadeIn(CreateUI, 0f, false));
                StartCoroutine(FadeIn(JoinUI, 0f, false));
                StartCoroutine(FadeIn(SelectChoose, 0f, false));
                StartCoroutine(FadeIn(FlyCr, 0f, false));
                StartCoroutine(FadeIn(FlyJo, 0f, false));
                StartCoroutine(FadeIn(roomNum, 1f, true));
                StartCoroutine(FadeIn(NumFrame, 1f, true));
                StartCoroutine(FadeIn(friend, 1f, true));
                
                break;
            case UIState.JoinRoom:
                uiState = UIState.JoinRoom;
                StartCoroutine(FadeIn(WaitUIFront, 0f, false));
                StartCoroutine(FadeIn(CreateUI, 0f, false));
                StartCoroutine(FadeIn(JoinUI, 0f, false));
                StartCoroutine(FadeIn(SelectChoose, 0f, false));
                StartCoroutine(FadeIn(FlyCr, 0f, false));
                StartCoroutine(FadeIn(FlyJo, 0f, false));
                StartCoroutine(FadeIn(roomNum, 1f, true));
                StartCoroutine(FadeIn(NumFrame, 1f, true));
                StartCoroutine(FadeIn(Enter, 1f, true));               
                break;

        }
    }

}
