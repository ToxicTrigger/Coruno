using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class EffectHead : MonoBehaviour
{
    public ParticleSystem Head;
    public List<ParticleSystem> Childs;

    void Start()
    {
        Childs = new List<ParticleSystem>();
        Head = GetComponent<ParticleSystem>();
        
        if (Head == null)
        {
            Debug.Log(gameObject.name);
            Debug.LogError("해당 오브젝트에는 파티클이 없습니다.");
        }
        else
        {
            int count = this.transform.childCount;
            if (count == 0) Debug.LogError("해당 오브젝트에는 자식이 없습니다.");
            var effects = transform.GetComponentsInChildren<ParticleSystem>();
            if (effects.Length == 0) Debug.LogError("해당 오브젝트의 자식 중에는 파티클이 없습니다.");
            foreach (var item in effects)
            {
                if(!Childs.Contains(item))
                Childs.Add(item);
            }
        }
    }

    public void EffectStart()
    {
        Head.Play();
        foreach (var item in Childs)
        {
            item.Play();
        }
    }

    public void EffectForceStop()
    {
        Head.Stop();
        Head.Clear();
        foreach (var item in Childs)
        {
            item.Stop();
            item.Clear();
        }
    }

    public void EffectStop()
    {
        Head.Stop();
        foreach (var item in Childs)
        {
            item.Stop();
        }
    }

    public void EffectReStart()
    {
        Head.Stop();
        Head.Play();
        foreach (var item in Childs)
        {
            item.Stop();
            item.Play();
        }
    }

    public void EffectPause()
    {
        Head.Pause();
        foreach (var item in Childs)
        {
            item.Pause();
        }
    }

    void Update()
    {
        if (Head.main.loop)
        {
            foreach (var item in Childs)
            {
                var state = item.main;
                state.loop = true;
            }
        }
        else
        {
            foreach (var item in Childs)
            {
                var state = item.main;
                state.loop = false;
            }
        }

        foreach (var item in Childs)
        {
            var scale = item.transform.localScale;
            scale.x = Head.transform.localScale.x;
            item.transform.localScale = scale;
        }
    }
}
