using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SihlouetteAni : MonoBehaviour
{
    public Animator ani;
    public string Key;
    public int Value;

    void Start()
    {
        if(ani == null) ani = GetComponent<Animator>();
    }

    public void changeKey(string key)
    {
        Key = key;
    }
    public void changeVal(int val)
    {
        Value = val;
    }

    public void commit()
    {
        ani.SetInteger(Key, Value);
    }

}
