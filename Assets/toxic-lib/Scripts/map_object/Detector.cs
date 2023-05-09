using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detector : MonoBehaviour
{
    public List<Collider2D> list;
    public Collider2D col;
    public bool Find;

    void Start()
    {
        col = GetComponent<Collider2D>();
        list.Add(game_manager.instance.localPlayer.GetComponent<Collider2D>());
    }

    private void OnTriggerStay2D(Collider2D other) 
    {
        foreach(var i in list)
        {
            if(i.gameObject.GetInstanceID() == other.gameObject.GetInstanceID())
            {
                Find = true;
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other) 
    {
        foreach(var i in list)
        {
            if(i.gameObject.GetInstanceID() == other.gameObject.GetInstanceID())
            {
                Find = false;
            }
        }
    }

    private void OnDrawGizmos() 
    {
        Gizmos.color = Color.yellow;
        if(col!= null)
        Gizmos.DrawWireCube(col.transform.position + (Vector3)col.offset, ((BoxCollider2D) col).size);    
    }
}
