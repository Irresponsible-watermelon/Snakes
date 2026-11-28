using Unity.AppUI.UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;

public class PauseUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private VisualElement menu_root;
    private int ui_version = -1;

    private UnityEngine.UIElements.Button close_button;
    private UnityEngine.UIElements.Button resume_button;
    private UnityEngine.UIElements.Button options_button;
    private UnityEngine.UIElements.Button restart_button;
    private UnityEngine.UIElements.Button quit_button;
    private bool saved_is_interactable;

private void Awake()
    {
        panel_renderer = GetComponent<PanelRenderer>();

        if (panel_renderer == null) return;

        panel_renderer.RegisterUIReloadCallback(OnUIReload);
    }

    private void Update()
    {
        if (GameManagerScript.Instance != null && GameManagerScript.Instance.is_paused && GameManagerScript.Instance.is_options)
        {
            SetPauseInteraction(false);
        }
        else SetPauseInteraction(true);
    }
    private void OnDestroy()
    {
        if (panel_renderer == null) return;
        panel_renderer.UnregisterUIReloadCallback(OnUIReload);
    }
    private void OnUIReload(PanelRenderer renderer, VisualElement root, int version)
    {
        if (version == ui_version) return;
        ui_version = version;
        menu_root = root;

        close_button = root.Q<UnityEngine.UIElements.Button>("CloseButton");
        resume_button = root.Q<UnityEngine.UIElements.Button>("ResumeButton");
        options_button = root.Q<UnityEngine.UIElements.Button>("OptionsButton");
        restart_button = root.Q<UnityEngine.UIElements.Button>("RestartButton");
        quit_button = root.Q<UnityEngine.UIElements.Button>("QuitButton");

    if (close_button == null || resume_button == null ||
        options_button == null || restart_button == null || quit_button == null)
    {
        Debug.LogError("A pause-menu button could not be found. Check its UXML Name.", this);
        return;
    }        
        
        close_button.clicked += OnCloseClicked;
        resume_button.clicked += OnResumeClicked;
        options_button.clicked += OnOptionsClicked;
        restart_button.clicked += OnRestartClicked;
        quit_button.clicked += OnQuitClicked;
    }

    private void OnCloseClicked()
    {
        SceneManager.UnloadSceneAsync("Pause");
    }
    private void OnResumeClicked()
    {
        SceneManager.UnloadSceneAsync("Pause");
    }
    private void OnOptionsClicked()
    {
        SceneManager.LoadSceneAsync("Options", LoadSceneMode.Additive);
    }
    private void OnRestartClicked()
    {
        DataManagerScript.Instance.cause_of_death = DataManagerScript.autopsy.RESTART;
        SceneManager.UnloadSceneAsync("Snake");
        SceneManager.LoadSceneAsync("Start");
        SceneManager.UnloadSceneAsync("Pause");
    }
    private void OnQuitClicked()
    {
        Application.Quit();
    }
    void SetPauseInteraction(bool is_interactble)
    {
        saved_is_interactable = is_interactble;
        menu_root?.SetEnabled(is_interactble);
    }
}
