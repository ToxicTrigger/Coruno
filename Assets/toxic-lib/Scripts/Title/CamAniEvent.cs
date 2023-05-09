using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamAniEvent : MonoBehaviour
{
    public Lobby lobby;
    private void Start()
    {
        lobby = GameObject.FindObjectOfType<Lobby>();
    }
    public void OnAniEvent()
    {
    }
}
