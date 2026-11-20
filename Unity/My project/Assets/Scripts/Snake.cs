using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Snake : MonoBehaviour
{

private Vector2 current_direction = Vector2.up;
private Vector2 pending_direction = Vector2.up;
private void FixedUpdate()
    {
        DirectionSet();
        Move();
    }

private void DirectionSet()
    {
        if (Input.GetKeyDown(KeyCode.W) && current_direction != Vector2.down)
        {
            pending_direction = Vector2.up;
        }
        else if (Input.GetKeyDown(KeyCode.S) && current_direction != Vector2.up)
        {
            pending_direction = Vector2.down;
        }
        else if (Input.GetKeyDown(KeyCode.A) && current_direction != Vector2.right)
        {
            pending_direction = Vector2.left;
        }
        else if (Input.GetKeyDown(KeyCode.D) && current_direction != Vector2.left)
        {
            pending_direction = Vector2.right;
        }
    }

private void Move()
    {
        switch (current_direcction)
        {
            case Vector2.up:
                self.transform.position.y += 1;
                break;
            case Vector2.down:
                self.transform.position.y -= 1;
                break;
            case Vector2.left:
                self.transform.position.x -= 1;
                break;
            case Vector2.right:
                self.transform.position.x += 1;
                break;
        }
    }

}

