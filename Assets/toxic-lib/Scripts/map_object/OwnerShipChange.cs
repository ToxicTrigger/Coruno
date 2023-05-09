using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class OwnerShipChange : MonoBehaviourPunCallbacks, IPunOwnershipCallbacks
{
    public impl_handle obj;

    private void Start()
    {
    }

    void Update()
    {
        if (obj.myActive)
        {
            if (!photonView.IsMine)
            {
                photonView.RequestOwnership();
            }
        }
    }

    public void OnOwnershipRequest(PhotonView targetView, Player requestingPlayer)
    {
        if (!obj.myActive)
        {
            this.photonView.TransferOwnership(requestingPlayer);
        }
    }

    public void OnOwnershipTransfered(PhotonView targetView, Player previousOwner)
    {

    }

}
