using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TogetherConnector : MonoBehaviour, IPressActive
{
    public int connectCount = 0;
    public bool publicActive;
    public GameObject[] activeObj;
    IPressActive[] IActives;

    private void Start()
    {
        IActives = new IPressActive[activeObj.Length];
        for (int i = 0; i < activeObj.Length; i++)
        {
            IActives[i] = activeObj[i].GetComponent<IPressActive>();
        }
    }

    void Update()
    {
        if (connectCount == 2)
        {
            if (!publicActive)
            {
                publicActive = true;
                foreach (IPressActive item in IActives)
                {
                    item.ActiveEX("gate3-1 open");
                }
            }
        }
    }

    public void Active(object obj)
    {
        if (!publicActive)
        {
            if ((int)obj == 1) //라토
            {
                DoRato(true);
            }
            else if ((int)obj == -1) // 니호
            {
                DoNiho(true);
            }
            connectCount++;
        }
    }
    public void ActiveEX(object obj)
    {

    }
    public void InoperActive(object obj)
    {
        if (!publicActive)
        {
            if ((int)obj == 1)
            {
                DoRato(false);
            }
            else if ((int)obj == -1)
            {
                DoNiho(false);
            }
            connectCount--;
        }
    }

    void DoRato(bool val)
    {
        if(val)//채움
        {
            foreach (IPressActive item in IActives)
            {
                item.Active("r_light");
            }
        }
        else
        {
            foreach (IPressActive item in IActives)
            {
                item.Active("r_lightOFF");
            }
        }
        
    }

    void DoNiho(bool val)
    {
        if (val)//채움
        {
            foreach (IPressActive item in IActives)
            {
                item.Active("b_light");
            }
        }
        else
        {
            foreach (IPressActive item in IActives)
            {
                item.Active("b_lightOFF");
            }
        }
    }
}
