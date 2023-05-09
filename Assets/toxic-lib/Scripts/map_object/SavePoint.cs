using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

[RequireComponent(typeof(PhotonView))]
public class SavePoint : MonoBehaviourPunCallbacks, Photon.Realtime.IOnEventCallback
{
    public int SavePointNum;
    SaveManager saveManager;
    private byte saveEvCode;
    public List<impl_observable> UpObjectList;
    public List<impl_observable> DownObjectList;
    public List<TriggerPlate> AniTriggerList;

    bool onMySave;
    bool onOtherSave;

    public bool isSaved;
    // Start is called before the first frame update
    void Start()
    {
        saveEvCode = (byte)photonView.ViewID;
        saveManager = game_manager.instance.GetComponent<SaveManager>();
        if(game_manager.instance.is_develop_mode)
        {
            onOtherSave = true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(onMySave&&onOtherSave&&!isSaved)
        {
            isSaved = true;
            foreach(impl_observable item in UpObjectList)
            {
                item.isclear = true;
            }
            foreach (impl_observable item in DownObjectList)
            {
                item.isclear = true;
            }
            saveManager.currentScene = UnityEngine.SceneManagement.SceneManager.GetActiveScene().name;
            saveManager.SavePoint = this.SavePointNum;
            saveManager.TemporarySave();
        }
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (!isSaved)
        {
            if (collision.gameObject.CompareTag("Player"))
            {
                onMySave = true;
                PhotonNetwork.RaiseEvent(saveEvCode, onMySave, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
            }
        }
    }

    public void ApplyLoad()
    {
        foreach (var obj in UpObjectList)
        {
            obj.ApplyLoad();
        }
        foreach (var obj in DownObjectList)
        {
            obj.ApplyLoad();
        }
        foreach(TriggerPlate item in AniTriggerList)
        {
            item.gameObject.SetActive(false);
        }
    }

    public void OnEvent(EventData photonEvent)
    {
        byte evCode = photonEvent.Code;
        if (evCode == saveEvCode)
        {
            onOtherSave = (bool)photonEvent.CustomData;
        }
    }
}
