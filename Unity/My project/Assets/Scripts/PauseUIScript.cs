using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;

public class PauseUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private int ui_version = -1;

    private Button close_button;
    private Button resume_button;
    private Button options_button;
    private Button restart_button;
    private Button quit_button;

private void Awake()
    {
        panel_renderer = GetComponent<PanelRenderer>();

        if (panel_renderer == null) return;

        panel_renderer.RegisterUIReloadCallback(OnUIReload);
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

        close_button = root.Q<Button>("CloseButton");
        resume_button = root.Q<Button>("ResumeButton");
        options_button = root.Q<Button>("OptionsButton");
        restart_button = root.Q<Button>("RestartButton");
        quit_button = root.Q<Button>("QuitButton");

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
    {}
    private void OnRestartClicked()
    {}
    private void OnQuitClicked()
    {
        Application.Quit();
    }
}
