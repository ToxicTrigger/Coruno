using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformPosConn : MonoBehaviour
{
    public GameObject[] platforms;
    public GameObject[] Positions;

    void Start()
    {
        this.Positions = new GameObject[this.transform.childCount];
        for(int i = 0; i < this.transform.childCount; ++i)
        {
            this.Positions[i] = this.transform.GetChild(i).gameObject;
        }
    }

    void Update()
    {
        for(int i = 0; i < this.Positions.Length; ++i)
        {
            this.platforms[i].transform.position = this.Positions[i].transform.position;
        }
    }
}
