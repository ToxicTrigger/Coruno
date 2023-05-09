using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public enum ObservableState
{
    Off,
    On,
    InOff,
    InOn
}
[RequireComponent(typeof(PhotonView))]
[RequireComponent(typeof(Priority))]
public abstract class impl_observable : MonoBehaviourPunCallbacks, impl_observe_net
{
    public List<impl_observer> observers;
    public ObservableState state;

    protected List<object> OriStates;
    protected List<object> ClearStates;
    public bool isclear;

    protected Priority priority;

    public bool isFast;

    private void Awake() 
    {
        OriStates = new List<object>();
        ClearStates = new List<object>();
    }
    protected void Start()
    {
        priority = GetComponent<Priority>();
        Add(game_manager.instance.localPlayer.GetComponent<impl_observer>());
    }

    protected void Update()
    {

    }

    public ObservableState GetState()
    {
        return this.state;
    }

    public bool Add(impl_observer observer)
    {
        if (!this.observers.Contains(observer))
        {
            this.observers.Add(observer);
            observer.targets.Add(this);
            return true;
        }
        return false;
    }

    public void ChangeState(bool OnOff)
    {
        if (OnOff)
        {
            if (!(this.state == ObservableState.InOn || this.state == ObservableState.On))
            {
                this.state = ObservableState.InOn;
            }
        }
        else
        {
            if (!(this.state == ObservableState.InOff || this.state == ObservableState.Off))
            {
                this.state = ObservableState.InOff;
            }
        }
    }

    public abstract void InvokeOff();
    public abstract void InvokeOn();
    public abstract void Off();
    public abstract void On();

    public abstract void ApplyLoad(); // 로드 했을 시 호출 함수

    public abstract GameObject Judgment(); // Active 가능한지 판별
    public abstract void ActiveClear();    // 비Active 상태로 전환시 해야할것들

    public abstract void SetFastPlayer();  // 동시에 Active 하면 안되는 오브젝트 거의 동시에 Active 했을 때 비교 후 호출 함수

    public void OnDrawGizmos()
    {

        foreach (var item in this.observers)
        {
            if (this.state == ObservableState.On)
            {
                Gizmos.color = new Color(174 / 255, 255 / 255, 47 / 255);
            }
            else
            {
                Gizmos.color = new Color(255 / 255, 125 / 255, 47 / 255);
            }
            if (item != null)
                Gizmos.DrawLine(transform.position, item.transform.position);

        }
    }
    private void OnApplicationQuit()
    {
        this.observers.Clear();
    }

    public IEnumerator CompareNetworkTime()
    {
        isFast = false;
        game_manager.instance.timeSycBool = false;
        game_manager.instance.otherActivePushTime = 0;
        game_manager.instance.photonView.RPC("SendATTime", RpcTarget.Others);
        yield return new WaitUntil(() => game_manager.instance.timeSycBool);
        if (game_manager.instance.MyActivePushTime < game_manager.instance.otherActivePushTime)
        {
            isFast = true;
        }
        SetFastPlayer();
    }
}
