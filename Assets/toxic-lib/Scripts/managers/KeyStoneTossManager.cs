using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class KeyStoneTossManager : MonoBehaviourPunCallbacks
{
    public enum KeyStoneState
    {
        HaveRato,
        HaveIO
    };
    public KeyStoneState keyStoneState;
    public bool otherEnd;
    public KeyStoneKai myStone;
    public KeyStoneKai currentStone;
    public KeyStoneKai RatoStone;
    public KeyStoneKai NihoStone;

    public GameObject bullet;
    public Animation  bulletAni;
    public float speed;
    bool init;

    void Update()
    {      
        if (!init)
        {
            if(game_manager.instance.localPlayer != null && game_manager.instance.RemotePlayer != null)
            {
                if (game_manager.instance.localPlayer.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                {
                    RatoStone = game_manager.instance.localPlayer.GetComponentInChildren<KeyStoneKai>(); ;
                    NihoStone = game_manager.instance.RemotePlayer.GetComponentInChildren<KeyStoneKai>(); ;
                }
                else
                {
                    RatoStone = game_manager.instance.RemotePlayer.GetComponentInChildren<KeyStoneKai>();
                    NihoStone = game_manager.instance.localPlayer.GetComponentInChildren<KeyStoneKai>();
                }
                myStone = game_manager.instance.localPlayer.GetComponentInChildren<KeyStoneKai>();
                otherEnd = true;
                bullet = GameObject.FindGameObjectWithTag("Bullet");
                bulletAni = bullet.GetComponent<Animation>();
                init = true;
            }
        }
        else
        {
            if(Input.GetButtonDown("KeyStoneSend") && myStone.haveKeystone && otherEnd)
            {
                Debug.Log("Tossbutton" + gameObject.name);
                myStone.haveKeystone = false;
                otherEnd = false;
                StartCoroutine(Toss());
                photonView.RPC("SendKeystone", RpcTarget.Others);
            }
        }
    }

    [PunRPC]
    public void SendKeystone()
    {
        otherEnd = false;
        StartCoroutine(Toss());
    }
    [PunRPC]
    public void SetOtherEnd()
    {
        otherEnd = true;
    }

    IEnumerator Toss()
    {
        
        currentStone.stone_ohra.PlayQueued("ohra_Close");
        yield return new WaitUntil(() => currentStone.stone_ohra.isPlaying == false);
        bullet.transform.position = currentStone.transform.position + (Vector3.up * 0.3f);
        bulletAni.PlayQueued("bullet_Open");
        KeyStoneKai recvKeyStoneKai = keyStoneState == KeyStoneState.HaveRato ? NihoStone : RatoStone;

        while (!Vector3.Distance(bullet.transform.position, recvKeyStoneKai.transform.position + (Vector3.up * 0.3f)).AlmostEquals(0.0f, 0.01f))
        {
            if (Vector3.Distance(bullet.transform.position, recvKeyStoneKai.transform.position) > 100)
            {
                break;
            }
            bullet.transform.position = Vector3.MoveTowards(bullet.transform.position, recvKeyStoneKai.transform.position + (Vector3.up * 0.3f), speed * Time.deltaTime);
            yield return new WaitForEndOfFrame();

        }   
        bulletAni.PlayQueued("bullet_Close");
        recvKeyStoneKai.stone_ohra.PlayQueued("ohra_Open");
        keyStoneState = keyStoneState == KeyStoneState.HaveRato ? KeyStoneState.HaveIO : KeyStoneState.HaveRato;
        currentStone = keyStoneState == KeyStoneState.HaveRato ? RatoStone : NihoStone;
        currentStone.haveKeystone = true;
        photonView.RPC("SetOtherEnd", RpcTarget.Others);
    }

}
