using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class Jump : MonoBehaviour, ISocket
{
    public enum Type
    {
        Up,
        InForce,
        Left,
        Right,
        Down
    }
    BoxCollider2D box;
    public Type type;
    public float Power;
    public bool isActive;
    public Animator ani;
    public MeshRenderer[] meshRenderers;
    [ColorUsageAttribute(true, true)]
    public Color des, ori, cur;
    public float speed;

    private void Start()
    {
        box = GetComponent<BoxCollider2D>();
        box.isTrigger = false;
        ani = GetComponent<Animator>();
        meshRenderers = GetComponentsInChildren<MeshRenderer>();
        ori = new Color(0, 0, 0);

        foreach (var item in meshRenderers)
        {
            item.material.SetColor("_emission_c", ori);
        }
    }

    public void SocketOff()
    {
        isActive = false;
    }

    public void SocketOn()
    {
        isActive = true;
    }

    private void FixedUpdate()
    {
        foreach (var item in meshRenderers)
        {
            float _Lerp_power = item.material.GetFloat("_Lerp_power");
            if(isActive)
            {
                cur = Color.Lerp( item.material.GetColor("_emission_c"), des, Time.deltaTime * speed);
                _Lerp_power =  Mathf.Lerp(_Lerp_power, 1, Time.deltaTime* speed);
            }
            else
            {
                cur = Color.Lerp(item.material.GetColor("_emission_c"), ori, Time.deltaTime* speed);
                _Lerp_power =  Mathf.Lerp(_Lerp_power, 0, Time.deltaTime* speed);
            }
            item.material.SetFloat("_Lerp_power", _Lerp_power);
            item.material.SetColor("_emission_c", cur);
        }
    }


    public bool used;
    private void OnCollisionStay2D(Collision2D other) 
    {
        if (isActive && !used)
        {
            ani.SetBool("Step", true);
            player p = other.gameObject.GetComponent<player>();

            switch (type)
            {
                case Type.Up:
                    other.gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.up * Power, ForceMode2D.Impulse);
                    break;
                case Type.InForce:
                    other.gameObject.GetComponent<Rigidbody2D>().AddForce((other.transform.position - this.transform.position).normalized * Power, ForceMode2D.Impulse);
                    break;
                case Type.Left:
                    other.gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.left * Power, ForceMode2D.Impulse);
                    break;
                case Type.Right:
                    other.gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.right * Power, ForceMode2D.Impulse);
                    break;
                case Type.Down:
                    other.gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.down * Power, ForceMode2D.Impulse);
                    break;

            }
            used = true;
        }
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        ani.SetBool("Step", false);
        used = false;
    }

    private void OnDrawGizmos()
    {
        if (isActive)
        {
            Gizmos.color = Color.blue;
        }
        else
        {
            Gizmos.color = Color.red;
        }
        // 점프 파워?
        Gizmos.DrawWireSphere(this.transform.position, Power);
    }
}
