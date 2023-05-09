using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class WaterWheel : MonoBehaviour, IRotActive
{
    public enum Azimuth
    {
        four,
        eight
    };
    public Azimuth spinAzimuth;

    public float speed;

    public bool startSpin;
    public bool activeEnd = true;
    Quaternion spinTarget;

    public float[] bakeAzi;

    int AziNum;
    int wheelAzi;

    public int startAziNum;

   
    private void Start()
    {
        wheelAzi = 0;
        AziNum = spinAzimuth == Azimuth.four ? 4 : 8;
        activeEnd = true;
        bakeAzi = new float[AziNum];
        if (AziNum == 4)
        {
            for (int i = 0; i < bakeAzi.Length; i++)
            {
                bakeAzi[i] = (360 / 4) * i;
            }
        }
        else
        {
            for (int i = 0; i < bakeAzi.Length; i++)
            {
                bakeAzi[i] = (360 / 8) * i;
            }
        }
        this.SetSaveData(startAziNum);
    }

    public void Active(float rot)
    {
        wheelAzi += (int)rot;

        if (wheelAzi == AziNum)
        {
            wheelAzi = 0;
        }
        spinTarget = Quaternion.Euler(Vector3.back * bakeAzi[wheelAzi]);
        activeEnd = false;
        AkSoundEngine.PostEvent("Play_wheel", this.gameObject);
    }
    public void InoperAtive()
    {
        
    }

    private void Update()
    {
        if (this.transform.rotation != spinTarget)
        {
            this.transform.rotation = Quaternion.RotateTowards(this.transform.rotation, spinTarget, speed * Time.deltaTime);
            if (this.transform.rotation == spinTarget && activeEnd != true)
            {
                activeEnd = true;
            }
        }

    }


    
    public bool GetActiveEnd()
    {
        return activeEnd;
    }

    public void SetSaveData(int rot)
    {
        this.transform.rotation = Quaternion.Euler(Vector3.forward * bakeAzi[rot]);
    }

    public int GetSaveData()
    {
        return this.startAziNum;
    }
}
