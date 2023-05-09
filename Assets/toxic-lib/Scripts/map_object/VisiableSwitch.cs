using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class VisiableSwitch : MonoBehaviourPunCallbacks
{
    public GameObject target;
    public float time;
    public bool event_on;

    public IEnumerator StartTimer()
    {
        event_on = true;
        target.SetActive(true);
        GetComponent<Collider>().enabled = false;
        GetComponent<MeshRenderer>().enabled = false;
        yield return new WaitForSeconds(this.time);
        GetComponent<Collider>().enabled = true;
        GetComponent<MeshRenderer>().enabled = true;
        target.SetActive(false);
        event_on = false;
    }

    [PunRPC]
    void SwitchControl()
    {
        this.StartCoroutine(this.StartTimer());
    }

    private void OnTriggerEnter(Collider other)
    {
        photonView.RPC("SwitchControl", RpcTarget.Others);
        this.StartCoroutine(this.StartTimer());
    }
}
