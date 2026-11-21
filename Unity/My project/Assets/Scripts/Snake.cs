using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine;

public class Snake : MonoBehaviour
{

public Vector2 current_direction = Vector2.up;
private Vector2 pending_direction = Vector2.up;
[SerializeField] private float cps_count = 1;
private float move_interval;
private float moveTimer;
private List<GameObject> body_parts;
private List<bool> is_corner;
private List<Vector2> dir_array;
public GameObject body_part_prefab;
// Startup
private void Start()
    {
        move_interval = 1 / cps_count;
        body_parts = new List<GameObject>();
        is_corner = new List<bool>();
        dir_array = new List<Vector2>();
        body_parts.Add(this.gameObject);
        is_corner.Add(false);
        dir_array.Add(Vector2.up);
        Grow(new Vector3(body_parts[0].transform.position.x, body_parts[0].transform.position.y - 1, 0));
        Grow(new Vector3(body_parts[1].transform.position.x, body_parts[1].transform.position.y - 1, 0));
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

    if (keyboard.wKey.wasPressedThisFrame && current_direction != Vector2.down && current_direction != Vector2.up)
    {   
        pending_direction = Vector2.up;
        is_corner[0] = true;
    }
    else if (keyboard.sKey.wasPressedThisFrame && current_direction != Vector2.up && current_direction != Vector2.down)
    {
        pending_direction = Vector2.down;
        is_corner[0] = true;
    }
    else if (keyboard.aKey.wasPressedThisFrame && current_direction != Vector2.right && current_direction != Vector2.left)
    {
        pending_direction = Vector2.left;
        is_corner[0] = true;
    }
    else if (keyboard.dKey.wasPressedThisFrame && current_direction != Vector2.left && current_direction != Vector2.right && current_direction != Vector2.left)
    {
        pending_direction = Vector2.right;
        is_corner[0] = true;
    }    
}   

private void Move()
{
    current_direction = pending_direction;

    dir_array[0] = current_direction;
    for (int i = dir_array.Count - 1; i > 0; i--)
    {   
            Vector2 prev_dir = dir_array[i - 1];

            dir_array[i] = prev_dir;
        }

    for (int i = is_corner.Count - 1; i > 0; i--)
    {
        is_corner[i] = is_corner[i - 1];
    }
    is_corner[0] = false;
    is_corner[is_corner.Count - 1] = false;
    
    for (int i = body_parts.Count - 1; i > 0; i--)
    {
        Transform part = body_parts[i].transform;
        Transform previous = body_parts[i - 1].transform;

        part.position = previous.position;
        if (i == is_corner.Count - 1)
        {
            RotateObject(part, dir_array[i]);
        }
        else if (!is_corner[i] || i == 0)  
        {
            part.rotation = previous.rotation;
        }
    }

    Transform head = body_parts[0].transform;
    head.position += new Vector3(current_direction.x, current_direction.y, 0);
    RotateObject(head, current_direction);
}

private void RotateObject(Transform obj, Vector2 direction)
{
 
    if (direction == Vector2.up)
        {
        obj.transform.rotation = Quaternion.Euler(0, 0, 0);
        }
    else if (direction == Vector2.down)
        {
            obj.transform.rotation = Quaternion.Euler(0, 0, 180);
        }
    else if (direction == Vector2.left)
        {
            obj.transform.rotation = Quaternion.Euler(0, 0, 90);
        }
    else if (direction == Vector2.right)
        {
            obj.transform.rotation = Quaternion.Euler(0, 0, 270);
        }
}

private void Grow(Vector3 position)
{
    GameObject new_part = Instantiate(body_part_prefab, position, body_parts[body_parts.Count - 1].transform.rotation);
    body_parts.Add(new_part);
    is_corner.Add(false);
    dir_array.Add(dir_array[dir_array.Count - 1]);
}
}

