;; Profile Manager Contract
;; Manages professional profiles for the endorsement system

;; Error constants
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_INPUT (err u101))
(define-constant ERR_PROFILE_NOT_FOUND (err u102))
(define-constant ERR_PROFILE_ALREADY_EXISTS (err u103))
(define-constant ERR_INVALID_PRINCIPAL (err u104))
(define-constant ERR_SKILL_NOT_FOUND (err u105))
(define-constant ERR_SKILL_ALREADY_EXISTS (err u106))

;; Data variables
(define-data-var contract-owner principal tx-sender)

;; Data maps
(define-map profiles
  { owner: principal }
  {
    name: (string-utf8 50),
    bio: (string-utf8 300),
    contact: (string-utf8 100),
    created-at: uint,
    last-updated: uint
  }
)

(define-map profile-skills
  { owner: principal, skill-id: uint }
  {
    name: (string-utf8 50),
    description: (string-utf8 200)
  }
)

(define-data-var next-skill-id uint u1)

;; Private functions
(define-private (is-valid-principal (address principal))
  (not (is-eq address 'SP000000000000000000002Q6VF78)))

;; Public functions
(define-public (create-profile 
    (name (string-utf8 50)) 
    (bio (string-utf8 300)) 
    (contact (string-utf8 100))
  )
  (let (
    (profile-key { owner: tx-sender })
  )
    (asserts! (is-none (map-get? profiles profile-key)) ERR_PROFILE_ALREADY_EXISTS)
    (asserts! (and (> (len name) u0) (<= (len name) u50)) ERR_INVALID_INPUT)
    (asserts! (and (> (len bio) u0) (<= (len bio) u300)) ERR_INVALID_INPUT)
    
    ;; Create new profile
    (map-set profiles profile-key
      {
        name: name,
        bio: bio,
        contact: contact,
        created-at: block-height,
        last-updated: block-height
      }
    )
    
    (print { event: "profile-created", owner: tx-sender, name: name })
    (ok tx-sender)))

(define-public (update-profile 
    (name (string-utf8 50)) 
    (bio (string-utf8 300)) 
    (contact (string-utf8 100))
  )
  (let (
    (profile-key { owner: tx-sender })
    (profile (unwrap! (map-get? profiles profile-key) ERR_PROFILE_NOT_FOUND))
  )
    (asserts! (and (> (len name) u0) (<= (len name) u50)) ERR_INVALID_INPUT)
    (asserts! (and (> (len bio) u0) (<= (len bio) u300)) ERR_INVALID_INPUT)
    
    ;; Update profile
    (map-set profiles profile-key
      {
        name: name,
        bio: bio,
        contact: contact,
        created-at: (get created-at profile),
        last-updated: block-height
      }
    )
    
    (print { event: "profile-updated", owner: tx-sender })
    (ok tx-sender)))

(define-public (add-skill
    (skill-name (string-utf8 50))
    (skill-description (string-utf8 200))
  )
  (let (
    (profile-key { owner: tx-sender })
    (skill-id (var-get next-skill-id))
    (skill-key { owner: tx-sender, skill-id: skill-id })
  )
    (asserts! (is-some (map-get? profiles profile-key)) ERR_PROFILE_NOT_FOUND)
    (asserts! (and (> (len skill-name) u0) (<= (len skill-name) u50)) ERR_INVALID_INPUT)
    (asserts! (and (> (len skill-description) u0) (<= (len skill-description) u200)) ERR_INVALID_INPUT)
    
    ;; Add skill to profile
    (map-set profile-skills skill-key
      {
        name: skill-name,
        description: skill-description
      }
    )
    
    ;; Increment skill ID counter
    (var-set next-skill-id (+ skill-id u1))
    
    (print { event: "skill-added", owner: tx-sender, skill-id: skill-id, name: skill-name })
    (ok skill-id)))

(define-public (update-skill
    (skill-id uint)
    (skill-name (string-utf8 50))
    (skill-description (string-utf8 200))
  )
  (let (
    (skill-key { owner: tx-sender, skill-id: skill-id })
    (skill (unwrap! (map-get? profile-skills skill-key) ERR_SKILL_NOT_FOUND))
  )
    (asserts! (and (> (len skill-name) u0) (<= (len skill-name) u50)) ERR_INVALID_INPUT)
    (asserts! (and (> (len skill-description) u0) (<= (len skill-description) u200)) ERR_INVALID_INPUT)
    
    ;; Update skill
    (map-set profile-skills skill-key
      {
        name: skill-name,
        description: skill-description
      }
    )
    
    (print { event: "skill-updated", owner: tx-sender, skill-id: skill-id })
    (ok skill-id)))

(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_UNAUTHORIZED)
    (asserts! (is-valid-principal new-owner) ERR_INVALID_PRINCIPAL)
    (ok (var-set contract-owner new-owner))))

;; Read-only functions
(define-read-only (get-profile (owner principal))
  (match (map-get? profiles { owner: owner })
    profile (ok profile)
    ERR_PROFILE_NOT_FOUND))

(define-read-only (get-skill (owner principal) (skill-id uint))
  (match (map-get? profile-skills { owner: owner, skill-id: skill-id })
    skill (ok skill)
    ERR_SKILL_NOT_FOUND))

(define-read-only (get-contract-owner)
  (var-get contract-owner))