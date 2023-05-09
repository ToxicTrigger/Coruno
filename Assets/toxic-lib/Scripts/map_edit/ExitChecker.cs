using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitChecker : MonoBehaviour
{
    private void OnCollisionExit2D(Collision2D other) 
    {
        Debug.Log("EX: " + this.gameObject.name + " : "  + other.gameObject.name );    
    }

    private void OnCollisionEnter2D(Collision2D other) 
    {
        Debug.Log("EN: " + this.gameObject.name + " : "  + other.gameObject.name );       
    }
}
