using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

public class GameManagerScript : MonoBehaviour
{
    private static GameManagerScript _instance;
    public static GameManagerScript Instance { get => _instance; private set => _instance = value; }
    public int score {get; private set;} = 0;
    public int difficulty {get; private set;} = 1;
    public float true_cps {get; private set;} = 1.0f;
    public bool is_paused =>
        SceneManager.GetSceneByName("Pause").isLoaded;
private void Awake()
{
    Debug.Log("START BEGIN");
    Instance = this;
    Debug.Log("START END");
}
private void Update()
    {
        key_inputs();
    }
    public void SurvivalScore()
    {
        score += Mathf.RoundToInt(Mathf.Max(1, difficulty * 2));
    }

    public void FoodScore()
    {
        score += Mathf.RoundToInt(Mathf.Max(100, (difficulty * 2) + (true_cps * 50) ));
    }
    public void OpenPauseMenu()
    {
        if (is_paused) return;
        else SceneManager.LoadSceneAsync("Pause", LoadSceneMode.Additive);    
    }
    public void ClosePauseMenu()
    {
        if (!is_paused) return;
        else SceneManager.UnloadSceneAsync("Pause");
    }
    private void key_inputs()
    {
        Keyboard keyboard = Keyboard.current;

        if (keyboard == null) return;

        if (keyboard.escapeKey.wasPressedThisFrame)
        {
            if (!is_paused ) OpenPauseMenu();
            else ClosePauseMenu();
        }
    }
}
