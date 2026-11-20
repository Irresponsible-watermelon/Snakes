using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine;

public class Snake : MonoBehaviour
{

private Vector2 current_direction = Vector2.up;
private Vector2 pending_direction = Vector2.up;
[SerializeField] private float cps_count = 1;
private float move_interval;
private float moveTimer;
// Startup
private void Start()
    {
        move_interval = 1 / cps_count;
    }
// Process loop
private void Update()
{
    DirectionSet();

    moveTimer += Time.deltaTime;
    if (moveTimer >= move_interval)
    {
        Move();
        moveTimer -= move_interval;
    }
}

// Frame loop
private void FixedUpdate()
{}

private void DirectionSet()
{   
    Keyboard keyboard = Keyboard.current;

    if (keyboard == null)
    {    return;
    }

    if (keyboard.wKey.wasPressedThisFrame && current_direction != Vector2.down)
    {
        pending_direction = Vector2.up;
    }
    else if (keyboard.sKey.wasPressedThisFrame && current_direction != Vector2.up)
    {
        pending_direction = Vector2.down;
    }
    else if (keyboard.aKey.wasPressedThisFrame && current_direction != Vector2.right)
    {
        pending_direction = Vector2.left;
    }
    else if (keyboard.dKey.wasPressedThisFrame && current_direction != Vector2.left)
    {
        pending_direction = Vector2.right;
    }    
}   

private void Move()
{
    current_direction = pending_direction;

    Vector3 position = transform.position;
    position.x += pending_direction.x;
    position.y += pending_direction.y;
    transform.position = position;
}

}

