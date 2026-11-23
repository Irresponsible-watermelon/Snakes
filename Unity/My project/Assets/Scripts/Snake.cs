using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine;

public class Snake : MonoBehaviour
{

public Vector2 current_direction {get ; private set; } = Vector2.up;
private Vector2 pending_direction = Vector2.up;
public float cps_count;
private float move_interval => 1f / cps_count;
private float moveTimer;
public List<GameObject> body_parts {get; private set; }
private List<bool> is_corner;
private List<Vector2> dir_array;
[SerializeField] private GameObject body_part_prefab;
[SerializeField] private GameObject map_box;
private List<float> edges;
public int survival_counter = 0;
public bool has_collided = false;
public bool has_initialised = false;
// Startup
private void Start()
    {
        cps_count = 1;
        body_parts = new List<GameObject>();
        edges = new List<float>(map_box.GetComponent<MapEdge>().edge_positions);
        is_corner = new List<bool>();
        dir_array = new List<Vector2>();
        body_parts.Add(this.gameObject);
        is_corner.Add(false);
        dir_array.Add(Vector2.up);
        Grow(new Vector3(body_parts[0].transform.position.x, body_parts[0].transform.position.y - 1, 0));
        Grow(new Vector3(body_parts[1].transform.position.x, body_parts[1].transform.position.y - 1, 0));
        has_initialised = true;
    }
// Process loop
private void Update()
{
    DirectionSet();
    

    if (!has_collided && !GameManagerScript.Instance.is_paused)
    {
    moveTimer += Time.deltaTime;
    if (moveTimer >= move_interval)
    {
        Move();
        moveTimer -= move_interval;
    }}
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
    else if (keyboard.wKey.wasPressedThisFrame && current_direction != Vector2.down && current_direction != Vector2.up)
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
    else if (keyboard.dKey.wasPressedThisFrame && current_direction != Vector2.left && current_direction != Vector2.right)
    {
        pending_direction = Vector2.right;
        is_corner[0] = true;
    }
    else return;       
}   

private void Move()
{  
    current_direction = pending_direction;
    dir_array[0] = current_direction;
    List<GameObject> sample_body_parts = new List<GameObject>(body_parts);

    // sort out head
    Vector3 new_head_pos = (Vector3)sample_body_parts[0].transform.position;
    new_head_pos += new Vector3(current_direction.x, current_direction.y, 0);
    RotateObject(sample_body_parts[0].transform, current_direction);

    has_collided = IsWallCollision(new_head_pos);
    // check if head in snake
    for (int i = 1; i < sample_body_parts.Count; i++)
        {
            if (new_head_pos == sample_body_parts[i].transform.position)
            {
                has_collided = true;
                print("Has_collided set true by snake in self");
                break;
            }
        }

    if (survival_counter <= 5)
        {
            GameManagerScript.Instance.SurvivalScore();
            survival_counter++;
        }
if (!has_collided){
    // Shift the direction array and corner flags down the body store direction seperate from body which only shows texture direction
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
    
    // Shift the body parts down the body and rotate them to match the direction of the previous part dependent on if the part is a corner or not
    for (int i = body_parts.Count - 1; i > 0; i--)
    {
        Transform part = sample_body_parts[i].transform;
        Transform previous = sample_body_parts[i - 1].transform;

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
    sample_body_parts[0].transform.position = new_head_pos;
    body_parts = new List<GameObject>(sample_body_parts);        

    
}}

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

public void Grow(Vector3 position)
{
    GameObject new_part = Instantiate(body_part_prefab, position, body_parts[body_parts.Count - 1].transform.rotation);
    new_part.name = "Body Part " + body_parts.Count;
    body_parts.Add(new_part);
    is_corner.Add(false);
    dir_array.Add(dir_array[dir_array.Count - 1]);
}

private bool IsWallCollision(Vector3 pos)
    {
        if (pos.y > edges[0]) return true;
        else if (pos.y < edges[1]) return true;
        else if (pos.x < edges[2]) return true;
        else if(pos.x > edges[3]) return true;
        else return false;
    }




}

