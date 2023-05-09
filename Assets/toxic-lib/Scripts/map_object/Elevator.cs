using UnityEngine;

public class Elevator : MonoBehaviour, IPressActive
{
    public float Speed = 1;
    Vector2 moveDir;
    Vector3 oriPos;
    public float dis;
    bool moveActive = false;
    Vector2 currentDir;

    void Start()
    {
        oriPos = this.transform.position;
        moveDir = Vector2.right;
    }

    private void Update()
    {
        if(moveActive)
        {
            this.transform.position = Vector3.MoveTowards(this.transform.position, (Vector2)oriPos + ((currentDir.normalized) * dis), Speed * Time.deltaTime);
        }
        else
        {
            //this.transform.position = Vector3.MoveTowards(this.transform.position, oriPos, Speed * Time.deltaTime);
        }
    }

    public void InoperActive(object obj)
    {
        moveActive = false;
    }

    public void Active(object obj)
    {
        moveActive = true;
        currentDir = moveDir * (int)obj;
    }
    public void ActiveEX(object obj)
    {

    }

}
