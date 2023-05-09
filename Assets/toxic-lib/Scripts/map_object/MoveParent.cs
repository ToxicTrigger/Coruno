using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(PhotonView))]
public class MoveParent : MonoBehaviourPunCallbacks
{
    public Transform myPair;
    public GameObject myParent;
    public bool isControl = true;

    private void OnCollisionEnter2D(Collision2D other)
    {
        if (isControl)
        {
            if (other.gameObject.CompareTag("Player") || other.gameObject.layer == LayerMask.NameToLayer("Box"))
            {
                if (myPair != null)
                {
                    other.transform.parent = this.transform;
                    SetNetParentWithPair(other, true);
                }
                else
                {
                    other.transform.parent = this.transform;
                    if (!game_manager.instance.is_develop_mode)
                        photonView.RPC("SetNetParent", RpcTarget.Others, 9999, other.gameObject.GetComponent<PhotonView>().ViewID, true);
                }
            }
        }
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        if (isControl)
        {
            if (other.gameObject.CompareTag("Player") || other.gameObject.layer == LayerMask.NameToLayer("Box"))
            {
                other.gameObject.transform.parent = null;

                SetNetParentWithPair(other, false);
            }
        }
    }


    [PunRPC]
    void SetNetParent(int platform, int PlayerViewId, bool isEnter)
    {
        if (isEnter)
        {
            if (platform != 9999)
            {
                PhotonView.Find(PlayerViewId).transform.parent = PhotonView.Find(platform).transform;
            }
        }
        else
        {
            PhotonView.Find(PlayerViewId).transform.parent = null;
        }
    }

    public void SetNetParentWithPair(Collision2D other, bool isEnter)
    {
        if (isEnter)
        {
            if (!game_manager.instance.is_develop_mode)
                photonView.RPC("SetNetParent", RpcTarget.Others, myPair.GetComponent<PhotonView>().ViewID, other.gameObject.GetComponent<PhotonView>().ViewID, true);
        }
        else
        {
            if (!game_manager.instance.is_develop_mode)
                photonView.RPC("SetNetParent", RpcTarget.Others, 9999, other.gameObject.GetComponent<PhotonView>().ViewID, false);
        }
    }

    public void Callback(GameObject other, bool isEnter)
    {
        if (photonView.IsMine || !game_manager.instance.is_develop_mode)
        {
            if (isEnter)
            {
                other.transform.parent = this.transform;
                photonView.RPC("SetNetParent", RpcTarget.Others, this.photonView.ViewID, other.gameObject.GetComponent<PhotonView>().ViewID, true);
            }
            else
            {
                other.gameObject.transform.parent = null;
                photonView.RPC("SetNetParent", RpcTarget.Others, 9999, other.gameObject.GetComponent<PhotonView>().ViewID, false);
            }
        }
    }
}
