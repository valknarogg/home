import { useQuery } from "@tanstack/react-query"
import { APP_VERSION } from "@repo/shared"
import semver from "semver"

type UpdateInfo = {
  hasUpdate: boolean
  latestVersion: string
}

type GithubRelease = {
  tag_name: string
}

async function fetchLatestRelease(): Promise<GithubRelease> {
  const res = await fetch(
    "https://api.github.com/repos/dcodesdev/LetterSpace/releases/latest"
  )
  if (!res.ok) throw new Error("Failed to fetch release")
  return res.json()
}

export function useUpdateCheck(): UpdateInfo {
  const { data } = useQuery({
    queryKey: ["latest-release"],
    queryFn: fetchLatestRelease,
    staleTime: 1000 * 60 * 10,
    retry: false,
    refetchInterval: 1000 * 60, // Every minute
  })

  const latestVersion = data?.tag_name?.replace("v", "") || APP_VERSION
  const hasUpdate = semver.gt(latestVersion, APP_VERSION)

  return { hasUpdate, latestVersion }
}
