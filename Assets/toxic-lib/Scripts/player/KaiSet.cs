using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KaiSet : MonoBehaviour
{
    
    public KeyStoneTossManager keyStoneTossManager;

    private void Start()
    {
        keyStoneTossManager = game_manager.instance.GetComponent<KeyStoneTossManager>();

    }

    public void setOwner()
    {
        keyStoneTossManager.RatoStone.haveKeystone = true;
        keyStoneTossManager.currentStone = keyStoneTossManager.RatoStone;
        keyStoneTossManager.keyStoneState = KeyStoneTossManager.KeyStoneState.HaveRato;
        keyStoneTossManager.RatoStone.stone_ohra.PlayQueued("ohra_Open");
    }
}
