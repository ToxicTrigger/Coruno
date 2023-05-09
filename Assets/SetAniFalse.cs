using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetAniFalse : MonoBehaviour
{
    public KeyStoneKai KeyStoneKai;
    // Start is called before the first frame update
    void SetFalse()
    {
        KeyStoneKai.doAni = false;
    }
}
