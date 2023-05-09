using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(PhotonView))]
public class impl_observer : MonoBehaviourPunCallbacks
{
    public List<impl_observable> targets;

    public void FixedUpdate()
    {
        foreach (var item in targets)
        {
            if(item == null) continue;
            switch (item.state)
            {
                case ObservableState.Off:
                    item.Off();
                    break;
                case ObservableState.On:
                    item.On();
                    break;
                case ObservableState.InOff:
                    item.InvokeOff();
                    item.state = ObservableState.Off;
                    break;
                case ObservableState.InOn:
                    item.InvokeOn();
                    item.state = ObservableState.On;
                    break;
            }
        }
    }

    public void ChangeState(bool OnOff)
    {
        foreach (var item in this.targets)
        {
            item.ChangeState(OnOff);
        }
    }

    public bool Add(impl_observable target)
    {
        if(targets.Contains(target)) return false;
        
        this.targets.Add(target);
        
        if(!target.observers.Contains(this)) 
        target.observers.Add(this);
        return true;
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawSphere(this.transform.position + Vector3.back * 5, 0.2f);

        foreach (var item in this.targets)
        {
            if(item == null) continue;
            if (item.state == ObservableState.On)
            {
                Gizmos.color = new Color(174 / 255, 255 / 255, 47 / 255);
            }
            else
            {
                Gizmos.color = new Color(255 / 255, 125 / 255, 47 / 255);
            }
            Gizmos.DrawCube(item.transform.position + Vector3.back * 5, Vector3.one * 0.4f);
        }
    }

    private void OnApplicationQuit() 
    {
        targets.Clear();
    }
}
