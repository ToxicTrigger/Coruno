using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class input_manager : trigger.impl_singletone<input_manager> 
{
    public List<trigger.impl_controllable> controllers;

    void Awake()
    {
        controllers = new List<trigger.impl_controllable>();
    }

    public void add(trigger.impl_controllable controller)
    {
        this.controllers.Add(controller);
    }

    void FixedUpdate()
    {
        foreach(var i in this.controllers)
        {
            if(i != null)
            i.update_user_input();
        }
    }
}